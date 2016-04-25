require 'rails_helper'

RSpec.feature "Account Management", type: :feature do
  feature "sign up" do
    context "with valid credentials" do
      let(:password) { Faker::Internet.password }

      scenario "User progresses to invitation screen" do
        visit "/accounts/sign_up"

        fill_in "First name", with: Faker::Name.first_name
        fill_in "Last name", with: Faker::Name.last_name
        fill_in "Organization", with: Faker::Company.name
        fill_in "Email", with: Faker::Internet.email
        fill_in "Password", with: password
        fill_in "Password confirmation", with: password

        click_button "Sign up"
        expect(page).to have_text("Send Invitation")
      end
    end

    context "with invalid credentials" do
      scenario "account creation fails" do
        visit "/accounts/sign_up"

        fill_in "First name", with: Faker::Name.first_name
        fill_in "Last name", with: Faker::Name.last_name
        fill_in "Organization", with: Faker::Company.name
        fill_in "Email", with: Faker::Internet.email
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "not the password"

        click_button "Sign up"
        expect(page).not_to have_text("Send Invitation")
        expect(page).to have_text("Password confirmation doesn't match Password")
      end
    end
  end

  feature "sign in" do
    context "with an account" do
      let(:organization) { create(:organization, :with_question, :with_account) }
      let(:account) { organization.accounts.first }

      scenario "it progresses to the dashboard" do
        visit "/accounts/sign_in"

        fill_in "Email", with: account.email
        fill_in "Password", with: "password"
        click_button "Sign in"
        expect(page).to have_text("Find a Caregiver")
      end
    end

    context "without an account" do
      scenario "it let's the user know the email or password is wrong" do
        visit "/accounts/sign_in"

        fill_in "Email", with: "bademail@example.com"
        fill_in "Password", with: "badpassword"
        click_button "Sign in"

        expect(page).to have_text("Invalid email or password.")
        expect(page).not_to have_text("Find a Caregiver")
      end
    end
  end

  feature "sign out" do
    let(:organization) { create(:organization, :with_question, :with_account)}
    let(:account) { organization.accounts.first }

    background(:each) do
      login_as(account, scope: :account)
    end

    scenario "it progresses to the sign in page" do
      visit "/"

      click_link "Sign out"
      expect(page).to have_text("You need to sign in or sign up before continuing.")
    end
  end
end
