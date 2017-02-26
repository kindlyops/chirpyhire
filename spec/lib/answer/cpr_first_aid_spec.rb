require 'rails_helper'

RSpec.describe Answer::CprFirstAid do
  let(:contact) { create(:contact) }
  let(:question) { Question::CprFirstAid.new(contact) }
  subject { Answer::CprFirstAid.new(question) }

  describe '#valid?' do
    context 'yes' do
      let(:message) { create(:message, body: 'yes') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end

    context 'yesterday...' do
      let(:message) { create(:message, body: 'yesterday all my troubles seem') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end

    context 'no' do
      let(:message) { create(:message, body: 'no') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe 'attribute' do
    context 'yes' do
      let(:message) { create(:message, body: 'yes') }

      it 'is nil' do
        expect(subject.attribute(message)[:cpr_first_aid]).to eq(nil)
      end
    end

    context 'no' do
      let(:message) { create(:message, body: 'no') }

      it 'is nil' do
        expect(subject.attribute(message)[:cpr_first_aid]).to eq(nil)
      end
    end
  end
end
