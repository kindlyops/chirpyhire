require 'rails_helper'

RSpec.feature "Rules" do
  let(:organization) { create(:organization,  :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all rules" do
    scenario "has a table of Rules" do
      visit rules_path
      expect(page).to have_text("Screen")
      expect(page).to have_text("Rule")
      expect(page).to have_text("Action")
      expect(page).to have_text("Status")
    end

    context "with rules" do
      let!(:rule) { create(:rule, organization: organization) }
      let(:description) { "Answers a question" }
      let(:action) { rule.actionable.decorate }
      let(:trigger_title) { rule.decorate.trigger.title }

      scenario "has the rule information" do
        visit rules_path
        expect(page).to have_text(trigger_title)
        expect(page).to have_text(action.template_name)
        expect(page).to have_text("Enabled")
      end
    end
  end
end
