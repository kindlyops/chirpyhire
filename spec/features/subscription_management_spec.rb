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

      click_on "submit-button"
      expect(page).to have_current_path(/\/subscriptions\/\d+/)
      expect(page).to have_text("Nice! Subscription created.")
    end
  end

  describe "upgrading a subscription", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
    let!(:organization) { create(:organization, :with_account, stripe_customer_id: stripe_customer.id) }
    let!(:account) { organization.accounts.first }
    let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
    let!(:subscription) { create(:subscription, plan: plan, organization: organization, quantity: 1, stripe_id: stripe_subscription.id) }

    it "works" do
      visit edit_subscription_path(subscription)

      within(find(".edit_subscription", match: :first)) do
        fill_in "subscription_quantity", with: "2"
      end

      click_on "Change Subscription"
      expect(page).to have_current_path(/\/subscriptions\/\d+/)
      expect(page).to have_text("Nice! Subscription changed.")
    end
  end

  describe "canceling a subscription", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
    let!(:organization) { create(:organization, :with_account, stripe_customer_id: stripe_customer.id) }
    let!(:account) { organization.accounts.first }
    let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
    let!(:subscription) { create(:subscription, state: "active", plan: plan, organization: organization, quantity: 1, stripe_id: stripe_subscription.id) }

    it "works" do
      visit edit_subscription_path(subscription)

      click_on "Cancel Subscription"
      expect(page).to have_current_path(/\/subscriptions\/\d+/)
      expect(page).to have_text("Sorry to see you go.")
    end
  end
end
