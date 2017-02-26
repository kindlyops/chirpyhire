require 'rails_helper'

RSpec.describe Answer::Experience do
  let(:contact) { create(:contact) }
  let(:question) { Question::Experience.new(contact) }
  subject { Answer::Experience.new(question) }

  describe '#valid?' do
    context 'new to caregiving' do
      let(:message) { create(:message, body: 'new to caregiving') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe 'attribute' do
    context 'new to caregiving' do
      let(:message) { create(:message, body: 'new to caregiving') }

      it 'is nil' do
        expect(subject.attribute(message)[:experience]).to eq(nil)
      end
    end
  end
end
