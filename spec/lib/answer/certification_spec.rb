require 'rails_helper'

RSpec.describe Answer::Certification do
  let(:contact) { create(:contact) }
  let(:question) { Question::Certification.new(contact) }
  subject { Answer::Certification.new(question) }

  describe '#valid?' do
    context 'pca' do
      let(:message) { create(:message, body: 'pca') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end

    context 'cna' do
      let(:message) { create(:message, body: 'cna') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe 'attribute' do
    context 'pca' do
      let(:message) { create(:message, body: 'pca') }

      it 'is nil' do
        expect(subject.attribute(message)[:certification]).to eq(nil)
      end
    end

    context 'cna' do
      let(:message) { create(:message, body: 'cna') }

      it 'is nil' do
        expect(subject.attribute(message)[:certification]).to eq(nil)
      end
    end
  end
end
