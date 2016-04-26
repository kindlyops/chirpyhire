require 'rails_helper'

RSpec.feature "Find a Caregiver" do
  let(:organization) { create(:organization, :with_question, :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }
  let(:question_title) { organization.questions.first.title }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "with a subscribed candidate" do
    let!(:candidate) { create(:candidate, :with_subscription, organization: organization) }

    scenario "notifies the user the search was created" do
      visit new_search_path

      check(question_title)
      click_button("Find a Caregiver")
      expect(page).to have_text("Finding a caregiver now.")
    end
  end

  context "without candidates" do
    scenario "notifies the user there are no subscribed candidates" do
      visit new_search_path

      check(question_title)
      click_button("Find a Caregiver")
      expect(page).to have_text("There are no subscribed candidates!")
    end
  end

  context "viewing a search" do
    let!(:search) { create(:search, account: account) }

    scenario "has a table of good fits" do
      visit search_path(search)
      expect(page).to have_text("Name")
      expect(page).to have_text("Phone")
      expect(page).to have_text("Referrer")
      expect(page).to have_text("Referrer Phone Number")
    end

    context "with a good fit" do
      let!(:good_fit) { create(:search_candidate, search: search, fit: SearchCandidate.fits[:good_fit]).candidate }

      scenario "has the good fit's info" do
        visit search_path(search)
        expect(page).to have_text(good_fit.name)
        expect(page).to have_text(good_fit.phone_number.phony_formatted)
        expect(page).to have_text(good_fit.last_referrer_name)
        expect(page).to have_text(good_fit.last_referrer_phone_number.phony_formatted)
      end
    end
  end

  context "viewing all searches" do
    scenario "has a table of searches" do
      visit searches_path
      expect(page).to have_text("Searches")
      expect(page).to have_text("Title")
      expect(page).to have_text("Result")
      expect(page).to have_text("Searcher")
      expect(page).to have_text("Created")
    end

    context "with searches" do
      include ActionView::Helpers::DateHelper

      let!(:search) { create(:search, account: account) }
      scenario "has the search information" do
        visit searches_path
        expect(page).to have_text(search.title)
        expect(page).to have_text(search.result)
        expect(page).to have_text(search.account_name)
        expect(page).to have_text("#{time_ago_in_words(search.created_at)}")
      end
    end
  end
end
