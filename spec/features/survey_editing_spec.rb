require 'rails_helper'

RSpec.feature "SurveyEditing", type: :feature, js: true do
  let(:account) { create(:account) }

  before(:each) do
    login_as(account, scope: :account)
  end

  let(:survey) { account.organization.create_survey }

  context "Choice Questions" do
    let(:category) { create(:category, name: "Availability") }
    let!(:choice_question) { create(:choice_question, category: category, survey: survey) }
    let!(:choice_question_option) { create(:choice_question_option, question: choice_question, letter: "a", text: "Live-in") }

    context "adding a Choice", js: true do
      it "works" do
        visit survey_path
        click_link("edit-question")
        click_link("Add choice")

        choice = all('.nested-fields').last
        within(choice) do
          fill_in "b)", with: "Another Option"
        end

        click_button("Save")
        save_and_open_page
      end
    end

    context "removing a Choice" do

    end

    context "editing a Choice" do

    end
  end
end
