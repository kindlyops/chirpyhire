require 'rails_helper'

RSpec.describe Answer::Experience do
  let(:contact) { create(:contact) }
  let(:question) { Question::Experience.new(contact) }
  subject { Answer::Experience.new(question) }

  describe '#valid?' do
    context 'new to caregiving' do
      let(:message) { create(:message, body: 'new to caregiving') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end
  end

  describe 'attribute' do
    context 'new to caregiving' do
      let(:message) { create(:message, body: 'new to caregiving') }

      it 'is true' do
        expect(subject.attribute(message)[:experience]).to eq(:no_experience)
      end
    end
  end
end
