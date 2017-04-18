require 'rails_helper'

RSpec.feature 'Account Management', type: :feature, js: true do
  feature 'sign up' do
    let(:organization_name) { 'Orn, Beer and Schaden' }
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    context 'with valid credentials' do
      let(:password) { Faker::Internet.password }

      before do
        allow(PhoneNumberProvisioner).to receive(:provision) do |organization|
          organization.update(phone_number: Faker::PhoneNumber.cell_phone)
        end
      end

      scenario 'User progresses to recruiting ad' do
        visit '/accounts/sign_up'

        fill_in 'Organization name', with: organization_name
        fill_in 'Organization location', with: '1000 E. Market St. 22902'
        fill_in 'Email', with: email
        fill_in 'Name', with: name
        fill_in 'Password', with: password

        click_button 'Create an account'
        expect(page).to have_text('Recruiting Ad')
        expect(Account.last.email).to eq(email)
        expect(Account.last.name).to eq(name)
        expect(Organization.last.name).to eq(organization_name)
      end
    end
  end

  feature 'sign in' do
    context 'with an account' do
      let(:organization) { create(:organization) }
      let(:account) { organization.accounts.first }

      scenario 'it progresses to the candidates' do
        visit '/accounts/sign_in'

        fill_in 'Email', with: account.email
        fill_in 'Password', with: 'password'
        click_button 'sign-in'
        expect(page).to have_text('Ready')
      end
    end
  end

  feature 'forgot password' do
    context 'with an account' do
      let(:organization) { create(:organization) }
      let(:account) { organization.accounts.first }

      scenario 'it sends an email with a password reset link that can reset the password' do
        visit '/accounts/password/new'

        fill_in 'Email', with: account.email
        click_button 'Send password reset email'
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
      click_button 'Send password reset email'
      expect(page).to have_text('receive a password recovery link')
    end
  end

  feature 'sign out' do
    let(:organization) { create(:organization) }
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
