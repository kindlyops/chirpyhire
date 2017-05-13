require 'rails_helper'

RSpec.describe 'Caregivers' do
  let(:account) { create(:account) }

  before do
    sign_in(account)
  end

  context 'with caregivers' do
    context 'filter PCA only' do
      let!(:pca) { create(:contact, :pca, organization: account.organization) }
      let!(:cna) { create(:contact, :cna, organization: account.organization) }

      let(:params) do
        {
          certification: ['pca']
        }
      end

      context 'without zipcode filter' do
        it 'returns only PCA caregivers' do
          get caregivers_path, params: params

          expect(response.body).not_to include(cna.handle)
          expect(response.body).to include(pca.handle)
        end
      end
    end

    context 'filtering availability' do
      let!(:live_in) { create(:contact, :live_in, organization: account.organization) }
      let!(:am) { create(:contact, :am, organization: account.organization) }
      let!(:pm) { create(:contact, :pm, organization: account.organization) }
      let!(:hourly) { create(:contact, :hourly, organization: account.organization) }

      before do
        live_in.person.update(nickname: 'Bob Live-In')
        am.person.update(nickname: 'Bill AM')
        pm.person.update(nickname: 'Brett PM')
        hourly.person.update(nickname: 'Richard Hourly')
      end

      context 'requesting live_in' do
        let(:params) do
          {
            availability: ['live_in']
          }
        end

        it 'returns only live in caregivers' do
          get caregivers_path, params: params

          expect(response.body).to include(live_in.handle)
          expect(response.body).not_to include(am.handle)
          expect(response.body).not_to include(pm.handle)
          expect(response.body).not_to include(hourly.handle)
        end

        context 'and am' do
          let(:params) do
            {
              availability: %w(live_in hourly_am)
            }
          end

          it 'returns only live in, am, and hourly caregivers' do
            get caregivers_path, params: params

            expect(response.body).to include(live_in.handle)
            expect(response.body).to include(am.handle)
            expect(response.body).to include(hourly.handle)
            expect(response.body).not_to include(pm.handle)
          end

          context 'and pm' do
            let(:params) do
              {
                availability: %w(live_in hourly_am hourly_pm)
              }
            end

            it 'returns only live in, am, pm, and hourly caregivers' do
              get caregivers_path, params: params

              expect(response.body).to include(live_in.handle)
              expect(response.body).to include(am.handle)
              expect(response.body).to include(hourly.handle)
              expect(response.body).to include(pm.handle)
            end
          end
        end

        context 'and pm' do
          let(:params) do
            {
              availability: %w(live_in hourly_pm)
            }
          end

          it 'returns only live in, pm, and hourly caregivers' do
            get caregivers_path, params: params

            expect(response.body).to include(live_in.handle)
            expect(response.body).to include(hourly.handle)
            expect(response.body).to include(pm.handle)
            expect(response.body).not_to include(am.handle)
          end
        end
      end

      context 'requesting am' do
        let(:params) do
          {
            availability: ['hourly_am']
          }
        end

        it 'returns only am and hourly caregivers' do
          get caregivers_path, params: params

          expect(response.body).to include(am.handle)
          expect(response.body).to include(hourly.handle)
          expect(response.body).not_to include(live_in.handle)
          expect(response.body).not_to include(pm.handle)
        end

        context 'and pm' do
          let(:params) do
            {
              availability: %w(hourly_am hourly_pm)
            }
          end

          it 'returns only am, pm, and hourly caregivers' do
            get caregivers_path, params: params

            expect(response.body).to include(am.handle)
            expect(response.body).to include(hourly.handle)
            expect(response.body).to include(pm.handle)
            expect(response.body).not_to include(live_in.handle)
          end
        end
      end

      context 'requesting pm' do
        let(:params) do
          {
            availability: ['hourly_pm']
          }
        end

        it 'returns only pm and hourly caregivers' do
          get caregivers_path, params: params

          expect(response.body).to include(pm.handle)
          expect(response.body).to include(hourly.handle)
          expect(response.body).not_to include(am.handle)
          expect(response.body).not_to include(live_in.handle)
        end
      end
    end

    context 'sort order' do
      let!(:pca) { create(:contact, :pca, organization: account.organization) }
      let!(:cna) { create(:contact, :cna, organization: account.organization) }

      it 'returns the newest records first' do
        get caregivers_path

        expect(response.body).to have_ordered(cna.handle, pca.handle)
      end
    end
  end
end
