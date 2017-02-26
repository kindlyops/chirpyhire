require 'rails_helper'

RSpec.describe Answer::Certification do
  let(:contact) { create(:contact) }
  let(:question) { Question::Certification.new(contact) }
  subject { Answer::Certification.new(question) }

  describe '#valid?' do
    context 'pca' do
      let(:message) { create(:message, body: 'pca') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end

    context 'cna' do
      let(:message) { create(:message, body: 'cna') }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end
  end

  describe 'attribute' do
    context 'pca' do
      let(:message) { create(:message, body: 'pca') }

      it 'is true' do
        expect(subject.attribute(message)[:certification]).to eq(:pca)
      end
    end

    context 'cna' do
      let(:message) { create(:message, body: 'cna') }

      it 'is true' do
        expect(subject.attribute(message)[:certification]).to eq(:cna)
      end
    end
  end
end
