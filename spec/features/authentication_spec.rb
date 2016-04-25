require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
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
  end
end
