require 'rails_helper'

RSpec.feature "Templates" do
  let(:organization) { create(:organization,  :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all templates" do
    scenario "has a table of templates" do
      visit templates_path
      expect(page).to have_text("Templates")
      expect(page).to have_text("Name")
      expect(page).to have_text("Body")
    end

    context "with templates" do
      let!(:template) { create(:template, organization: organization) }
      scenario "has the template information" do
        visit templates_path
        expect(page).to have_text(template.name)
        expect(page).to have_text(template.body)
      end
    end
  end
end
