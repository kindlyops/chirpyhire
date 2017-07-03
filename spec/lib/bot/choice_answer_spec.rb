require 'rails_helper'

RSpec.describe Bot::ChoiceAnswer do
  let(:follow_up) { create(:choice_follow_up, rank: rank) }
  let(:message) { create(:message, body: body) }

  subject { Bot::ChoiceAnswer.new(follow_up) }

  describe 'activated?' do
    context 'rank is 1' do
      let(:rank) { 1 }

      context 'message is A' do
        let(:body) { 'A' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is space space A' do
        let(:body) { '  A' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is A space space' do
        let(:body) { 'A  ' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is A newline' do
        let(:body) { "A\n" }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is newline A' do
        let(:body) { "\nA" }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is Another one bites the dust' do
        let(:body) { 'Another one bites the dust' }

        it 'is false' do
          expect(subject.activated?(message)).to eq(false)
        end
      end

      context 'message is A OK' do
        let(:body) { 'A OK' }

        it 'is false' do
          expect(subject.activated?(message)).to eq(false)
        end
      end
    end

    context 'rank is 5' do
      let(:rank) { 5 }

      context 'message is E' do
        let(:body) { 'E' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is space space E' do
        let(:body) { '  E' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is E space space' do
        let(:body) { 'E  ' }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is E newline' do
        let(:body) { "E\n" }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is newline E' do
        let(:body) { "\nE" }

        it 'is true' do
          expect(subject.activated?(message)).to eq(true)
        end
      end

      context 'message is E veryday' do
        let(:body) { 'E veryday' }

        it 'is false' do
          expect(subject.activated?(message)).to eq(false)
        end
      end

      context 'message is Eewwwww' do
        let(:body) { 'Eewwwww' }

        it 'is false' do
          expect(subject.activated?(message)).to eq(false)
        end
      end
    end
  end
end
