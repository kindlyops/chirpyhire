require 'rails_helper'

RSpec.describe Bot::ZipcodeAnswer do
  let(:follow_up) { create(:zipcode_question).follow_ups.first }
  let!(:message) { create(:message, :conversation_part, body: body) }
  let(:contact) { message.contact }

  subject { Bot::ZipcodeAnswer.new(follow_up) }

  describe 'activated?' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, :conversation_part, body: '30342') }
        let!(:zipcode) { create(:zipcode, '30342'.to_sym) }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end

        context 'and follow up location flag is true' do
          it 'sets the zipcode for the message contact' do
            expect {
              subject.activated?(message)
            }.to change { contact.reload.zipcode.present? }.from(false).to(true)
          end
        end

        context 'and follow up location flag is false' do
          before do
            follow_up.update(location: false)
          end

          it 'does not set the zipcode for the message contact' do
            expect {
              subject.activated?(message)
            }.not_to change { contact.reload.zipcode.present? }
            expect(contact.zipcode.present?).to eq(false)
          end
        end
      end

      context 'not a zipcode', vcr: { cassette_name: 'ZipcodeFetcher-invalid' } do
        let(:message) { create(:message, body: '02162') }
        it 'is false' do
          expect(subject.activated?(message)).to eq(false)
        end
      end
    end

    context 'not 5 digits' do
      let(:message) { create(:message, body: '12312009') }

      it 'is false' do
        expect(subject.activated?(message)).to eq(false)
      end
    end
  end
end
