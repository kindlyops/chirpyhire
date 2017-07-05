require 'rails_helper'

RSpec.describe Answer::Zipcode do
  let(:contact) { create(:contact) }
  let(:question) { Question::ZipCode.new(contact) }
  subject { question.answer }

  describe '#valid?' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, body: '30342') }
        let!(:zipcode) { create(:zipcode, '30342'.to_sym) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end

      context 'not a zipcode', vcr: { cassette_name: 'ZipcodeFetcher-invalid' } do
        let(:message) { create(:message, body: '02162') }
        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
        end
      end
    end

    context 'not 5 digits' do
      let(:message) { create(:message, body: '12312009') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe '#attribute' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, body: '30342') }

        it 'is true' do
          expect(subject.attribute(message)[:zipcode]).to eq('30342')
        end
      end
    end
  end
end
