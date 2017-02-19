require 'rails_helper'

RSpec.describe Answer::Zipcode do
  let(:subscriber) { create(:subscriber) }
  let(:question) { Question::Zipcode.new(subscriber) }
  subject { Answer::Zipcode.new(question) }

  describe '#valid?' do
    context '5 digits' do
      context 'valid zip code' do
        let(:message) { create(:message, body: '30342') }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end

      context 'not a zip code' do
        let(:message) { create(:message, body: '11111') }
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
end
