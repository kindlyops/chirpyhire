require 'rails_helper'

RSpec.feature "Account Management", type: :feature, js: true do
  feature "sign up" do
    context "with valid credentials" do
      let(:password) { Faker::Internet.password }

      scenario "User progresses to invitation screen" do
        visit "/accounts/sign_up"

        fill_in "First name", with: Faker::Name.first_name
        fill_in "Last name", with: Faker::Name.last_name
        fill_in "Organization Name", with: Faker::Company.name
        fill_in "Organization Address", with: "1000 E. Market St. 22902"
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
        fill_in "Organization Name", with: Faker::Company.name
        fill_in "Organization Address", with: "1000 E. Market St. 22902"
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
      let(:organization) { create(:organization,  :with_account) }
      let(:account) { organization.accounts.first }

      scenario "it progresses to the dashboard" do
        visit "/accounts/sign_in"

        fill_in "Email", with: account.email
        fill_in "Password", with: "password"
        click_button "Sign in"
        expect(page).to have_text("Candidates")
      end
    end

    context "without an account" do
      scenario "it let's the user know the email or password is wrong" do
        visit "/accounts/sign_in"

        fill_in "Email", with: "bademail@example.com"
        fill_in "Password", with: "badpassword"
        click_button "Sign in"

        expect(page).to have_text("Invalid Email or password.")
        expect(page).not_to have_text("Candidates")
      end
    end
  end

  feature "forgot password" do
    context "with an account" do
      let(:organization) { create(:organization,  :with_account) }
      let(:account) { organization.accounts.first }

      scenario "it sends an email with a password reset link that can reset the password" do
        visit "/accounts/password/new"

        fill_in "Email", with: account.email
        click_button "Reset password"
        open_email(account.email)
        current_email.click_link("Change my password")
        fill_in "New password", with: "s3cr$t$$"
        fill_in "Confirm new password", with: "s3cr$t$$"
        click_button "Change my password"
        expect(page).to have_text("Your password has been changed successfully. You are now signed in.")
      end
    end

    scenario "it gives the password reset message" do
      visit "/accounts/password/new"

      fill_in "Email", with: Faker::Internet.email
      click_button "Reset password"
      expect(page).to have_text("receive a password recovery link")
    end
  end

  feature "sign out" do
    let(:organization) { create(:organization,  :with_account)}
    let(:account) { organization.accounts.first }

    background(:each) do
      login_as(account, scope: :account)
    end

    scenario "it progresses to the sign in page" do
      visit "/"

      find("#desktop-settings").trigger('click')
      click_link "Sign out"
      expect(page).to have_text("Sign in or sign up before continuing.")
    end
  end
end
