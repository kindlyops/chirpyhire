require 'rails_helper'

RSpec.describe AnswerClassifier do
  let(:classifier) { AnswerClassifier.new(answer, inquiry) }

  describe '#classify' do
    context 'choice question inquiry' do
      let(:message) { create(:message, body: 'B)') }
      let(:question) { create(:choice_question, choice_question_options_attributes: [{ letter: 'a', text: 'original A' }]) }
      let!(:option_a) { question.choice_question_options.first }
      let!(:option_b) { create(:choice_question_option, choice_question: question, letter: 'b') }

      let!(:inquiry) { create(:inquiry, question: question) }
      let!(:answer) { build(:answer, message: message) }

      context 'in which the option selected at the time the inquiry was made is no longer available' do
        with_versioning do
          it 'can still determine that is is a valid answer to the choice inquiry' do
            question.reload
            question.update(updated_at: Time.current, choice_question_options_attributes: [{ id: option_b.id, _destroy: true }])
            expect(classifier.classify).to eq(ChoiceQuestion)
          end
        end
      end
    end
    context 'zipcode question inquiry' do
      let(:message) { create(:message, body: '30342') }
      let(:question) { create(:zipcode_question, zipcode_question_options_attributes: [{ text: '30327' }, { text: '30342' }, { text: '30305' }]) }
      let(:inquiry) { create(:inquiry, question: question) }
      let(:answer) { build(:answer, message: message) }
      let(:expected_properties) do
        {
          zipcode_option: '30342',
          child_class: ZipcodeQuestion.child_class_property
        }
      end
      context 'whose answer is in the list of valid zipcode options' do
        it 'classifies the answer as for a zipcode question' do
          expect(classifier.classify).to eq(ZipcodeQuestion)
        end
      end

      context 'whose answer is not in the list of valid zipcode options' do
        let(:message) { create(:message, body: '20010') }
        it 'still classifies as for a zipcode question' do
          expect(classifier.classify).to eq(ZipcodeQuestion)
        end
      end
    end
  end
end
