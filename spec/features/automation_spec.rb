require 'rails_helper'

RSpec.feature "Automation" do
  let(:organization) { create(:organization,  :with_account)}
  let(:account) { organization.accounts.first }
  let(:automation) { create(:automation, organization: organization)}

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all rules" do
    scenario "has a table of Rules" do
      visit automation_path(automation)
      expect(page).to have_text("Screen")
      expect(page).to have_text("Trigger")
      expect(page).to have_text("Action")
      expect(page).to have_text("Status")
    end

    context "with rules" do
      let!(:rule) { create(:rule, :answer_trigger, automation: automation) }
      let(:description) { "Answers a question" }
      let(:action) { rule.action.decorate }
      let(:trigger_title) { rule.decorate.trigger_title }

      scenario "has the rule information" do
        visit automation_path(automation)
        expect(page).to have_text(trigger_title)
        expect(page).to have_text(action.template_name)
        expect(page).to have_text("Enabled")
      end
    end
  end
end
