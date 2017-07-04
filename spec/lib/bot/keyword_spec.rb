require 'rails_helper'

RSpec.describe Bot::Keyword do
  let(:bot) { create(:bot) }
  let(:message) { create(:message, body: body) }
  subject { Bot::Keyword.new(bot, message) }

  describe '#activated?' do
    context 'START as body' do
      let(:body) { 'START' }
      it 'is true' do
        expect(subject.activated?).to eq(true)
      end
    end

    context 'START. as body' do
      let(:body) { 'START.' }
      it 'is true' do
        expect(subject.activated?).to eq(true)
      end
    end

    context 'YES as body' do
      let(:body) { 'YES' }
      it 'is false' do
        expect(subject.activated?).to eq(false)
      end
    end

    context 'start as body' do
      let(:body) { 'start' }
      it 'is true' do
        expect(subject.activated?).to eq(true)
      end
    end

    context 'START in body' do
      context 'with whitespace' do
        let(:body) { '    START ' }

        it 'is true' do
          expect(subject.activated?).to eq(true)
        end
      end

      context 'with additional text' do
        let(:body) { 'START to do the limbo?' }

        it 'is true' do
          expect(subject.activated?).to eq(true)
        end
      end
    end

    context 'START not in body' do
      let(:body) { 'Another body' }

      it 'is false' do
        expect(subject.activated?).to eq(false)
      end
    end
  end
end
