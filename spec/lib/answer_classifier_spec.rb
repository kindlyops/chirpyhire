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
    context 'whitelist question inquiry' do
      let(:message) { create(:message, body: '30342') }
      let(:question) { create(:whitelist_question, whitelist_question_options_attributes: [{ text: '30327' }, { text: '30342' }, { text: '30305'} ]) }
      let(:inquiry) { create(:inquiry, question: question) }
      let(:answer) { build(:answer, message: message) }
      let(:expected_properties) do
        {
          whitelist_option: '30342',
          child_class: WhitelistQuestion.child_class_property
        }
      end
      context 'which is in the whitelist' do
        it 'classifies the answer as for a whitelist question' do
          expect(classifier.classify).to eq(WhitelistQuestion)
        end
      end

      context 'which is not in the whitelist' do 
        let(:message) { create(:message, body: '20010')}
        it 'is unable to classify the answer' do
          expect { classifier.classify }.to raise_error(AnswerClassifier::NotClassifiedError)
        end
      end
    end
  end
end
