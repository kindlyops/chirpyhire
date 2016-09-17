# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let!(:organization) { create(:organization, :with_account) }
  let(:inviter) { organization.accounts.first }

  let(:invite_params) do
    { account: { email: 'bob@example.com' } }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:account]
  end

  describe '#create' do
    before do
      sign_in(inviter)
    end

    it 'creates the user' do
      expect do
        post :create, params: invite_params
      end.to change { organization.users.count }.by(1)
    end
  end

  describe '#update' do
    let(:email) { 'bob@someemail.com' }
    let(:account) { Account.invite!({ email: email }, inviter) }
    let!(:user) { create(:user) }

    before do
      account.update(user: user)
    end

    let(:invite_params) do
      { account: {
        email: email,
        invitation_token: account.raw_invitation_token,
        password: 'password',
        password_confirmation: 'password',
        agreed_to_terms: true,
        user_attributes: {
          first_name: 'Bob',
          last_name: 'Bobson'
        }
      } }
    end

    it 'agrees to the terms' do
      put :update, params: invite_params
      expect(Account.last.agreed_to_terms?).to eq(true)
    end
  end
end
