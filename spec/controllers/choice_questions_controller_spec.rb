require 'rails_helper'

RSpec.describe ChoiceQuestionsController, type: :controller do
  let(:account) { create(:account) }
  let(:survey) { account.organization.create_survey }
  before(:each) do
    sign_in(account)
  end

  describe "#update" do
    let!(:question) { create(:choice_question, survey: survey) }

    context "with existing choice options" do
      let!(:old_choice_question_option) { create(:choice_question_option, letter: "a", choice_question: question) }
      let!(:old_choice_question_options) do
        [
         old_choice_question_option
        ]
      end

      context "and only changing choice options" do
        let(:params) do
          {
            id: question.id,
            choice_question: {
              choice_question_options_attributes: [
                id: old_choice_question_option.id,
                letter: "q"
              ]
            }
          }
        end

        it "still changes the updated_at on the question" do
          expect {
            put :update, params
          }.to change{question.reload.updated_at}
        end

        with_versioning do
          it "tracks the prior association" do
            put :update, params: params
            old_question = question.versions.last.reify(has_many: true)
            expect(old_question.choice_question_options.map(&:letter)).to match_array(["a"])
          end
        end
      end
    end
  end
end
