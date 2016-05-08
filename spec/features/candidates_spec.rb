require 'rails_helper'

RSpec.feature "Candidates" do
  let(:organization) { create(:organization,  :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all candidates" do
    scenario "has a table of candidates" do
      visit candidates_path
      expect(page).to have_text("Candidates")
      expect(page).to have_text("Name")
      expect(page).to have_text("Phone")
      expect(page).to have_text("Last Referrer")
      expect(page).to have_text("Last Referred")
    end

    context "with candidates" do
      include ActionView::Helpers::DateHelper

      let!(:candidate) { create(:candidate, :with_referral, organization: organization) }
      scenario "has the candidate information" do
        visit candidates_path
        expect(page).to have_text(candidate.name)
        expect(page).to have_text(candidate.phone_number.phony_formatted)
        expect(page).to have_text(candidate.last_referrer_name)
        expect(page).to have_text("#{time_ago_in_words(candidate.last_referred_at)}")
      end
    end
  end
end
