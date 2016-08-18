require 'rails_helper'

RSpec.feature "Account Invitations", type: :feature, js: true do
  include Features::InvitationHelpers
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:email) { Faker::Internet.email }

  background(:each) do
    login_as(account, scope: :account)
  end

  feature "sending an invitation" do
    scenario "notifies the user that the invitation was sent" do
      send_invitation_to(email)
      expect(page).to have_text("An invitation email has been sent to #{email}")
    end
  end

  feature "receiving an invitation" do
    background(:each) do
      send_invitation_to(email)
      logout(:account)
    end

    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }

    scenario "accepting the invitation takes the new account to the dashboard" do
      open_email(email)
      current_email.click_link("Accept invitation")

      fill_in "Name", with: "#{first_name} #{last_name}"
      fill_in "Password", with: "password"

      click_button "Sign up"
      expect(page).to have_text("Candidates")
      expect(User.last.first_name).to eq(first_name)
      expect(User.last.last_name).to eq(last_name)
    end
  end
end
