require 'rails_helper'

RSpec.describe Answer::Transportation do
  let(:contact) { create(:contact) }
  let(:question) { Question::Transportation.new(contact) }
  subject { Answer::Transportation.new(question) }

  describe '#valid?' do
    context 'personal transportation' do
      let(:message) { create(:message, body: 'personal transportation') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end

    context 'public transportation' do
      let(:message) { create(:message, body: 'public transportation') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end

    context 'do not have reliable transportation' do
      let(:message) { create(:message, body: 'do not have reliable transportation') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe 'attribute' do
    context 'personal transportation' do
      let(:message) { create(:message, body: 'personal transportation') }

      it 'is nil' do
        expect(subject.attribute(message)[:transportation]).to eq(nil)
      end
    end

    context 'public transportation' do
      let(:message) { create(:message, body: 'public transportation') }

      it 'is nil' do
        expect(subject.attribute(message)[:transportation]).to eq(nil)
      end
    end

    context 'do not have reliable transportation' do
      let(:message) { create(:message, body: 'do not have reliable transportation') }

      it 'is nil' do
        expect(subject.attribute(message)[:transportation]).to eq(nil)
      end
    end
  end
end
