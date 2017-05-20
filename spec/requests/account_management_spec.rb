require 'rails_helper'

RSpec.describe 'Account Management' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  describe 'editing your profile' do
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }

    let(:params) {
      {
        account: {
          email: email,
          person_attributes: {
            name: name
          }
        }
      }
    }

    it 'lets the user edit their name' do
      expect {
        put account_path(account), params: params
      }.to change { account.reload.name }.to(name)
    end

    it 'lets the user edit their email' do
      expect {
        put account_path(account), params: params
      }.to change { account.reload.email }.to(email)
    end
  end

  describe 'changing your password' do
    let(:current_password) { '$3cret$$' }
    let(:new_password) { 'password' }

    let(:params) do
      {
        account_id: account.id,
        account: {
          current_password: current_password,
          password: new_password,
          password_confirmation: new_password
        }
      }
    end

    before do
      account.update(password: current_password)
    end

    it 'lets you change your password' do
      expect {
        put account_settings_password_path(account), params: params
      }.to change { account.reload.encrypted_password }
    end
  end
end
