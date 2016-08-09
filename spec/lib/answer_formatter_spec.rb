require 'rails_helper'

RSpec.describe AnswerFormatter do
  let(:formatter) { AnswerFormatter.new(answer, inquiry) }

  describe "#format" do
    context "choice question inquiry" do
      let(:message) { create(:message, body: "B)") }
      let(:question) { create(:choice_question, choice_question_options_attributes: [{letter: "a", text: "original A"}]) }
      let!(:option_a) { question.choice_question_options.first }
      let!(:option_b) { create(:choice_question_option, choice_question: question, letter: "b") }

      let!(:inquiry) { create(:inquiry, question: question) }
      let!(:answer) { build(:answer, message: message) }

      context "in which the option selected at the time the inquiry was made is no longer available" do
        with_versioning do
          it "can still determine that is is a valid answer to the choice inquiry" do
            question.reload
            question.update(updated_at: Time.current, choice_question_options_attributes: [{id: option_b.id, _destroy: true}])
            expect(formatter.format).to eq("ChoiceQuestion")
          end
        end
      end
    end
  end
end
