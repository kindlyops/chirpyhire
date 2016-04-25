require 'rails_helper'

RSpec.feature "Leads" do
  let(:organization) { create(:organization, :with_question, :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all leads" do
    scenario "has a table of leads" do
      visit leads_path
      expect(page).to have_text("Leads")
      expect(page).to have_text("Name")
      expect(page).to have_text("Phone")
      expect(page).to have_text("Last Referrer")
      expect(page).to have_text("Last Referred")
    end

    context "with leads" do
      include ActionView::Helpers::DateHelper

      let!(:lead) { create(:lead, :with_referral, organization: organization) }
      scenario "has the lead information" do
        visit leads_path
        expect(page).to have_text(lead.name)
        expect(page).to have_text(lead.phone_number.phony_formatted)
        expect(page).to have_text(lead.last_referrer_name)
        expect(page).to have_text("#{time_ago_in_words(lead.last_referred_at)}")
      end
    end
  end
end
