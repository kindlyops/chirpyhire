require 'rails_helper'

RSpec.feature "SurveyEditing", type: :feature, js: true do
  let(:account) { create(:account) }
  let!(:location) { create(:location, organization: account.organization) }

  before(:each) do
    login_as(account, scope: :account)
  end

  let(:survey) { account.organization.create_survey }

  context "Address Questions" do
    let(:label) { "Address" }
    let!(:address_question) { create(:address_question, label: label, survey: survey) }

    context "editing the text" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        fill_in "address_question_text", with: "New question text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New question text")
      end
    end

    context "changing the status" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        find("#address_question_status", visible: :all).trigger('click')
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
      end
    end

    context "geofence limit" do
      before(:each) do
        Capybara.current_driver = :webkit
      end

      after(:each) do
        Capybara.current_driver = :poltergeist
      end

      context "adding a question" do
        it "works" do
          visit survey_path
          click_link("Add Question")
          within(find("#address-type")) do
            click_link("Add Question")
          end
          fill_in "address_question_label", with: "Fancy Address Label"
          fill_in "address_question_text", with: "Fancy Address Text"
          click_button("Save")
          expect(page).to have_text("Nice! Question saved.")
          expect(page).to have_text("Fancy Address Text")
          expect(page).to have_text("Fancy Address Label")
        end
      end

      context "that exists" do
        let!(:address_question_option) { create(:address_question_option, address_question: address_question) }

        context "removing the limit" do
          it "works" do
            visit survey_path
            find("#edit-question").trigger("click")

            address_option = find(".nested-fields", match: :first)
            within(address_option) do
              click_link("×")
            end

            click_button("Save")
            expect(page).to have_text("Nice! Question saved.")
            expect(page).not_to have_text("#{address_question_option.distance} miles")
          end
        end

        context "editing the limit" do
          let(:distance) { Faker::Number.number(2) }

          it "works" do
            visit survey_path
            find("#edit-question").trigger("click")

            address_option = find(".nested-fields", match: :first)
            within(address_option) do
              fill_in "address_question_address_question_option_attributes_distance", with: distance
            end

            click_button("Save")
            expect(page).to have_text("Nice! Question saved.")
          end
        end
      end

      context "adding the limit" do
        let(:distance) { Faker::Number.number(2) }
        let(:latitude) { Faker::Address.latitude }
        let(:longitude) { Faker::Address.longitude }

        it "works" do
          visit survey_path
          expect(page).not_to have_text("miles")
          find("#edit-question").trigger("click")

          click_link("Limit address range")
          option = find(".nested-fields", match: :first)
          within(option) do
            fill_in "address_question_address_question_option_attributes_distance", with: distance
          end

          click_button("Save")
          expect(page).to have_text("Nice! Question saved.")
        end

        it "only allows adding one option" do
          visit survey_path
          expect(page).not_to have_text("miles")
          find("#edit-question").trigger("click")

          click_link("Limit address range")
          expect(page).not_to have_text("Limit address range")
        end
      end
    end
  end

  context "Document Questions" do
    let(:label) { "CNA License" }
    let!(:document_question) { create(:document_question, label: label, survey: survey) }

    context "adding a question" do
      it "works" do
        visit survey_path
        click_link("Add Question")
        within(find("#image-type")) do
          click_link("Add Question")
        end
        fill_in "document_question_label", with: "Fancy Document Label"
        fill_in "document_question_text", with: "Fancy Document Text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("Fancy Document Text")
        expect(page).to have_text("Fancy Document Label")
      end
    end

    context "editing the text" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        fill_in "document_question_text", with: "New question text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New question text")
      end
    end

    context "changing the status" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        find("#document_question_status", visible: :all).trigger('click')
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
      end
    end
  end

  context "Choice Questions" do
    let(:label) { "Availability" }
    let!(:choice_question) { create(:choice_question, label: label, survey: survey, choice_question_options_attributes: [
        {letter: "a", text: "Live-in"}
      ]) }
    let!(:choice_question_option) { choice_question.choice_question_options.first }

    context "adding a question" do
      it "works" do
        visit survey_path
        click_link("Add Question")
        within(find("#choice-type")) do
          click_link("Add Question")
        end
        fill_in "choice_question_label", with: "Fancy Choice Label"
        fill_in "choice_question_text", with: "Fancy Choice Text"
        fill_in "choice_question_choice_question_options_attributes_0_text", with: "Choice A"
        fill_in "choice_question_choice_question_options_attributes_1_text", with: "Choice B"

        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("Fancy Choice Text")
        expect(page).to have_text("Fancy Choice Label")
        expect(page).to have_text("Choice A")
        expect(page).to have_text("Choice B")
      end
    end

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
      let!(:choice_question_option_2) { create(:choice_question_option, choice_question: choice_question, letter: "b", text: "Both") }
      it "works" do
        visit survey_path
        click_link("edit-question")
        choice = find(".nested-fields", match: :first)
        choice_text = choice.find('.field input').value
        within(choice) do
          find(".remove_fields", match: :first).trigger('click')
        end
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).not_to have_text(choice_text)
      end
    end

    context "editing the text" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        fill_in "choice_question_text", with: "New question text"
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
        expect(page).to have_text("New question text")
      end
    end


    context "changing the status" do
      it "works" do
        visit survey_path
        click_link("edit-question")

        find("#choice_question_status", visible: :all).trigger('click')
        click_button("Save")
        expect(page).to have_text("Nice! Question saved.")
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
