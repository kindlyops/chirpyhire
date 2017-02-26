require 'rails_helper'

RSpec.describe Answer::Transportation do
  let(:contact) { create(:contact) }
  let(:question) { Question::Transportation.new(contact) }
  subject { Answer::Transportation.new(question) }

  describe '#valid?' do
    context 'personal transportation' do
      let(:message) { create(:message, body: 'personal transportation') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end

    context 'public transportation' do
      let(:message) { create(:message, body: 'public transportation') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end

    context 'do not have reliable transportation' do
      let(:message) { create(:message, body: 'do not have reliable transportation') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end
  end

  describe 'attribute' do
    context 'personal transportation' do
      let(:message) { create(:message, body: 'personal transportation') }

      it 'is true' do
        expect(subject.attribute(message)[:transportation]).to eq(:personal_transportation)
      end
    end

    context 'public transportation' do
      let(:message) { create(:message, body: 'public transportation') }

      it 'is true' do
        expect(subject.attribute(message)[:transportation]).to eq(:public_transportation)
      end
    end

    context 'do not have reliable transportation' do
      let(:message) { create(:message, body: 'do not have reliable transportation') }

      it 'is true' do
        expect(subject.attribute(message)[:transportation]).to eq(:no_transportation)
      end
    end
  end
end
