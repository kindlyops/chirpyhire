require 'rails_helper'

RSpec.feature "Triggers" do
  let(:organization) { create(:organization,  :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all triggers" do
    scenario "has a table of Triggers" do
      visit triggers_path
      expect(page).to have_text("Screen")
      expect(page).to have_text("Trigger")
      expect(page).to have_text("Action")
      expect(page).to have_text("Status")
    end

    context "with triggers" do
      let!(:trigger) { create(:trigger, :with_observable, :with_actions, organization: organization) }
      let(:description) { "Answers Question" }
      let(:actions) { trigger.actions }

      scenario "has the trigger information" do
        visit triggers_path
        expect(page).to have_text(description)
        expect(page).to have_text(actions.first.description)
        expect(page).to have_text(actions.last.description)
        expect(page).to have_text("Enabled")
      end
    end
  end
end
