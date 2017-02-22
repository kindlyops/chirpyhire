require 'rails_helper'

RSpec.feature 'Account Management', type: :feature, js: true do
  feature 'sign up' do
    let!(:plan) { create(:plan) }
    let(:name) { 'Orn, Beer and Schaden' }
    let(:email) { Faker::Internet.email }
    context 'with valid credentials' do
      let(:password) { Faker::Internet.password }

      before do
        allow(PhoneNumberProvisionerJob).to receive(:perform_later)
      end

      scenario 'User progresses to ideal candidate screen' do
        visit '/accounts/sign_up'

        fill_in 'Agency Name', with: name
        fill_in 'Agency Location', with: '1000 E. Market St. 22902'
        fill_in 'Email', with: email
        fill_in 'Password', with: password

        click_button 'Sign up'
        expect(page).to have_text('Ideal Candidate')
        expect(Account.last.email).to eq(email)
        expect(Organization.last.name).to eq(name)
      end
    end
  end

  feature 'sign in' do
    context 'with an account' do
      let(:organization) { create(:organization,  :with_account, :with_subscription) }
      let(:account) { organization.accounts.first }

      scenario 'it progresses to the candidates' do
        visit '/accounts/sign_in'

        fill_in 'Email', with: account.email
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
        expect(page).to have_text('Candidates')
      end
    end
  end

  feature 'forgot password' do
    context 'with an account' do
      let(:organization) { create(:organization,  :with_account, :with_subscription) }
      let(:account) { organization.accounts.first }

      scenario 'it sends an email with a password reset link that can reset the password' do
        visit '/accounts/password/new'

        fill_in 'Email', with: account.email
        click_button 'Reset Password'
        open_email(account.email)
        current_email.click_link('Change My Password')
        fill_in 'New password', with: 's3cr$t$$'
        fill_in 'Confirm new password', with: 's3cr$t$$'
        click_button 'Change My Password'
        expect(page).to have_text('Your password has been changed successfully. You are now signed in.')
      end
    end

    scenario 'it gives the password reset message' do
      visit '/accounts/password/new'

      fill_in 'Email', with: Faker::Internet.email
      click_button 'Reset Password'
      expect(page).to have_text('receive a password recovery link')
    end
  end

  feature 'sign out' do
    let(:organization) { create(:organization, :with_subscription, :with_account) }
    let(:account) { organization.accounts.first }

    background(:each) do
      login_as(account, scope: :account)
    end

    scenario 'it progresses to the sign in page' do
      visit '/'

      find('#settingsDropdown').trigger('click')
      find('#sign-out').trigger('click')
      expect(page).to have_text('sign in or sign up before continuing.')
    end
  end
end
