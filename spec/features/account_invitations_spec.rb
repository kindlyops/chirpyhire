require 'rails_helper'

RSpec.feature "Account Invitations" do
  include Features::InvitationHelpers
  let(:organization) { create(:organization,  :with_account) }
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

    let(:invited) { build(:account, user: create(:user, organization: organization)) }

    scenario "accepting the invitation takes the new account to the dashboard" do
      open_email(email)
      current_email.click_link("Accept invitation")

      fill_in "First name", with: invited.first_name
      fill_in "Last name", with: invited.last_name

      fill_in "Password", with: invited.password
      fill_in "Password confirmation", with: invited.password_confirmation

      click_button "Set your password"
      expect(page).to have_text("Find a Caregiver")
    end
  end
end
