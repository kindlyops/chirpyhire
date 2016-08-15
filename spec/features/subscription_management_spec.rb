require 'rails_helper'

RSpec.feature "Subscription Management", type: :feature, js: true, stripe: { plan: "test" } do
  let(:organization) { create(:organization,  :with_account)}
  let(:account) { organization.accounts.first }
  let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }

  background(:each) do
    login_as(account, scope: :account)
  end

  describe "creating a subscription" do
    it "works" do
      visit new_subscription_path
      within(find("#new_subscription")) do
        fill_in "number", with: "4242424242424242"
        fill_in "name", with: "Bob Bobson"
        fill_in "address_zip", with: "12345"
        fill_in "expiry", with: "01/#{Time.current.year + 1}"
        fill_in "cvc", with: "123"
      end

      click_on "submit"
      expect(page).to have_current_path(/\/subscriptions\/\d+\/edit/)
    end
  end
end
