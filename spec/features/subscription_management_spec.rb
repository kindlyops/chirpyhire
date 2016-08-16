require 'rails_helper'

RSpec.feature "Subscription Management", type: :feature, js: true do
  let!(:stripe_plan) { Stripe::Plan.create(id: "test", amount: 5_000, currency: "usd", interval: "month", name: "test") }

  after(:each) do
    stripe_plan.delete
  end

  let(:organization) { create(:organization, :with_subscription, :with_account, phone_number: Faker::PhoneNumber.cell_phone)}
  let(:account) { organization.accounts.first }
  let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }

  background(:each) do
    login_as(account, scope: :account)
  end

  describe "creating a subscription", vcr: { cassette_name: "Subscription-Management-creating-a-subscription" } do
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

  describe "changing a subscription" do
    let(:card) do
      {
        number: "4242424242424242",
        exp_month: "8",
        exp_year: 1.year.from_now.year,
        cvc: "123"
      }
    end

    let(:stripe_customer) { Stripe::Customer.create }
    let(:stripe_token) { Stripe::Token.create(card: card) }
    let!(:stripe_card) { stripe_customer.sources.create(source: stripe_token.id) }
    let!(:stripe_subscription) { stripe_customer.subscriptions.create(plan: stripe_plan.id) }

    after(:each) do
      stripe_customer.delete
    end

    let!(:organization) { create(:organization, :with_account, phone_number: Faker::PhoneNumber.cell_phone, stripe_customer_id: stripe_customer.id) }
    let!(:account) { organization.accounts.first }
    let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
    let!(:subscription) { create(:subscription, plan: plan, state: "active", organization: organization, quantity: 1, stripe_id: stripe_subscription.id) }

    describe "upgrading a subscription", vcr: { cassette_name: "Subscription-Management-updating-a-subscription" } do
      it "works" do
        visit edit_subscription_path(subscription)

        within(find(".edit_subscription", match: :first)) do
          fill_in "subscription_quantity", with: "2"
        end

        click_on "Update Subscription"
        expect(page).to have_current_path(/\/subscriptions\/\d+/)
        expect(page).to have_text("Nice! Subscription changed.")
      end
    end

    describe "canceling a subscription", vcr: { cassette_name: "Subscription-Management-canceling-a-subscription" } do
      it "works" do
        visit edit_subscription_path(subscription)

        click_on "Cancel Subscription"
        expect(page).to have_current_path(/\/subscriptions\/\d+/)
        expect(page).to have_text("Sorry to see you go.")
      end
    end
  end
end
