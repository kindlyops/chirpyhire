require 'rails_helper'

RSpec.feature "Rules" do
  let(:organization) { create(:organization, :with_account) }
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all rules" do
    scenario "has a table of Rules" do
      visit rules_path
      expect(page).to have_text("Automation")
      expect(page).to have_text("Trigger")
      expect(page).to have_text("Action")
      expect(page).to have_text("Status")
    end

    context "with rules" do
      let!(:rule) { create(:rule, trigger: "screen", organization: organization) }
      let(:description) { "Screened" }
      let(:action) { rule.action.decorate }
      let(:trigger_title) { rule.decorate.trigger_title }

      scenario "has the rule information" do
        visit rules_path
        expect(page).to have_text(trigger_title)
        expect(page).to have_text(action.name)
        expect(page).to have_text("Enabled")
      end

      scenario "each rule leads to the rule's page", js: true do
        visit rules_path
        find(:xpath, "//tr[@data-link]").click
        expect(page).to have_text("Automation Rule")
        expect(page).to have_text("Trigger")
        expect(page).to have_text("Action")
        expect(page).to have_text(action.title)
        expect(page).to have_text(action.subtitle)
      end
    end
  end
end
