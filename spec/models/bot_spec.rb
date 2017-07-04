require 'rails_helper'

RSpec.describe Bot do
  subject { create(:bot) }

  describe '#question_after' do
    let!(:first_question) { create(:question, bot: subject) }
    let!(:second_question) { create(:question, bot: subject) }

    context 'with a question after' do
      context 'that is active' do
        it 'is the question' do
          expect(subject.question_after(first_question)).to eq(second_question)
        end
      end

      context 'that is not active' do
        before do
          second_question.update(active: false)
        end

        it 'is nil' do
          expect(subject.question_after(first_question)).to eq(nil)
        end
      end
    end

    context 'with two questions after' do
      let!(:third_question) { create(:question, bot: subject) }

      context 'and the next is not active' do
        before do
          second_question.update(active: false)
        end

        it 'is the following question' do
          expect(subject.question_after(first_question)).to eq(third_question)
        end
      end
    end
  end
end
