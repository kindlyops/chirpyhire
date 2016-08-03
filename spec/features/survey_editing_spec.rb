require 'rails_helper'

RSpec.feature "SurveyEditing", type: :feature, js: true do
  let(:account) { create(:account) }

  before(:each) do
    login_as(account, scope: :account)
  end

  let(:survey) { account.organization.create_survey }

  context "Address Questions" do
    let(:category) { create(:category, name: "Address") }
    let!(:address_question) { create(:address_question, category: category, survey: survey) }

    context "editing the text" do
      it "works" do
        visit survey_path
        click_link("edit-question")
        expect(page).to have_text(address_question.text)

        fill_in "address_question_text", with: "New question text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New question text")
      end
    end
  end

  context "Document Questions" do
    let(:category) { create(:category, name: "CNA License") }
    let!(:document_question) { create(:document_question, category: category, survey: survey) }
    context "editing the text" do
      it "works" do
        visit survey_path
        click_link("edit-question")
        expect(page).to have_text(document_question.text)

        fill_in "document_question_text", with: "New question text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New question text")
      end
    end
  end


  context "Choice Questions" do
    let(:category) { create(:category, name: "Availability") }
    let!(:choice_question) { create(:choice_question, category: category, survey: survey) }
    let!(:choice_question_option) { create(:choice_question_option, question: choice_question, letter: "a", text: "Live-in") }

    context "adding a Choice" do
      it "works" do
        visit survey_path
        click_link("edit-question")
        click_link("Add choice")
        choice = all('.nested-fields').last

        within(choice) do
          fill_in "b)", with: "Another Option"
        end
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("Another Option")
      end
    end

    context "removing a Choice" do
      let!(:choice_question_option_2) { create(:choice_question_option, question: choice_question, letter: "b", text: "Both") }
      it "works" do
        visit survey_path
        click_link("edit-question")
        choice = find(".nested-fields", match: :first)
        choice_text = choice.find('.field input').value
        within(choice) do
          click_link("×")
        end
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).not_to have_text(choice_text)
      end
    end

    context "editing a Choice" do
      it "works" do
        visit survey_path
        click_link("edit-question")
        choice = find(".nested-fields", match: :first)
        within(choice) do
          fill_in "a)", with: "New Choice"
        end
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New Choice")
      end
    end
  end
end
