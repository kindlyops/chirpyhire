require 'rails_helper'

RSpec.describe Bot::ZipcodeAnswer do
  let(:follow_up) { create(:zipcode_follow_up) }
  let(:message) { create(:message, body: body) }
  let(:person) { message.contact.person }

  subject { Bot::ZipcodeAnswer.new(follow_up) }

  describe 'activated?' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, body: '30342') }
        let!(:zipcode) { create(:zipcode, '30342'.to_sym) }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end

        it 'sets the zipcode for the message person' do
          expect {
            subject.activated?(message)
          }.to change { person.reload.zipcode.present? }.from(false).to(true)
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
