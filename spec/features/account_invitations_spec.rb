require 'rails_helper'

RSpec.describe 'Account Invitations', type: :feature, js: true do
  include Features::InvitationHelpers
  let(:organization) { create(:organization, :with_account) }
  let(:account) { organization.accounts.first }
  let(:email) { Faker::Internet.email }

  before do
    login_as(account, scope: :account)
  end

  describe 'sending an invitation' do
    it 'notifies the user that the invitation was sent' do
      send_invitation_to(email)
      expect(page).to have_text("An invitation email has been sent to #{email}")
    end
  end

  describe 'receiving an invitation' do
    before do
      send_invitation_to(email)
      logout(:account)
    end

    it 'accepting the invitation takes the new account to the dashboard' do
      open_email(email)
      current_email.click_link('Accept invitation')
      fill_in 'Password', with: 'password'

      click_button 'Sign Up'
      expect(page).to have_text('Candidates')
      expect(Account.active).to include(Account.find_by(email: email))
    end
  end
end
