require 'rails_helper'

RSpec.describe AddressRefresher do
  let(:message) { create(:message) }

  describe '#call' do
    context 'with a csv passed' do
      let(:csv) { CSV.new('') }
      let(:refresher) { AddressRefresher.new(message, csv: csv) }

      context 'message has an address' do
        context 'with a candidate', vcr: { cassette_name: 'AddressFinder-valid-address' } do
          let!(:candidate) { create(:candidate, user: message.user) }
          let(:message) { create(:message, body: '4059 Mt Lee Dr 90068') }

          it 'returns an array of results' do
            expect(refresher.call).to include(message.id, message.body)
          end

          it 'appends a row to the csv object' do
            expect(csv).to receive(:<<)
            refresher.call
          end

          context 'with an existing address' do
            let!(:address_feature) { create(:candidate_feature, :address, candidate: candidate, id: 10_293) }

            it 'returns an array of results with the feature id' do
              expect(refresher.call).to include(address_feature.id, address_feature.properties['address'])
            end
          end
        end

        context 'without a candidate' do
          it 'returns no address found' do
            expect(refresher.call).to eq('No address found')
          end
        end
      end

      context 'message does not have an address' do
        it 'returns no address found' do
          expect(refresher.call).to eq('No address found')
        end
      end
    end

    context 'without a csv passed' do
      let(:refresher) { AddressRefresher.new(message) }

      context 'message has an address' do
        context 'with a candidate', vcr: { cassette_name: 'AddressFinder-valid-address' } do
          let!(:candidate) { create(:candidate, user: message.user) }
          let(:survey) { create(:survey, organization: candidate.organization) }
          let(:message) { create(:message, body: '4059 Mt Lee Dr 90068') }

          context 'with an address persona feature' do
            let!(:question) { create(:address_question, survey: survey) }

            it 'creates a candidate feature' do
              expect do
                refresher.call
              end.to change { candidate.candidate_features.count }.by(1)
            end
          end

          context 'with an existing address' do
            let!(:address_feature) { create(:candidate_feature, :address, candidate: candidate, id: 10_293) }
            let(:street_address) { address_feature.properties['address'] }

            it 'does not create a candidate feature' do
              expect do
                refresher.call
              end.not_to change { candidate.candidate_features.count }
            end

            it 'updates the existing candidate feature' do
              expect do
                refresher.call
              end.to change { address_feature.reload.properties['address'] }.from(street_address).to('Mount Lee Drive, McNeil, CA 90068, United States of America')
            end
          end
        end

        context 'without a candidate' do
          it 'returns no address found' do
            expect(refresher.call).to eq('No address found')
          end
        end
      end

      context 'message does not have an address' do
        it 'returns no address found' do
          expect(refresher.call).to eq('No address found')
        end
      end
    end
  end
end
