require 'rails_helper'

RSpec.feature 'Account Management', type: :feature, js: true do
  feature 'sign in' do
    context 'with an account' do
      let(:organization) { create(:organization, :account) }
      let(:account) { organization.accounts.first }

      scenario 'it progresses to the candidates' do
        visit '/accounts/sign_in'

        fill_in 'Email', with: account.email
        fill_in 'Password', with: 'password'
        click_button 'sign-in'
        expect(page).to have_text('No caregivers found')
      end
    end
  end

  feature 'forgot password' do
    scenario 'it gives the password reset message' do
      visit '/accounts/password/new'

      fill_in 'Email', with: Faker::Internet.email
      click_button 'Send password reset email'
      expect(page).to have_text('receive a password recovery link')
    end
  end

  feature 'sign out' do
    let(:organization) { create(:organization, :account) }
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
