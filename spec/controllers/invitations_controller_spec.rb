require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let!(:organization) { create(:organization, :with_account) }
  let(:inviter) { organization.accounts.first }

  let(:invite_params) do
    {
      account: {
        email: 'bob@example.com',
        person_attributes: {
          name: Faker::Name.name
        }
      }
    }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:account]
  end

  describe '#create' do
    before do
      sign_in(inviter)
    end

    it 'creates the account' do
      expect {
        post :create, params: invite_params
      }.to change { organization.accounts.count }.by(1)
    end
  end

  describe '#update' do
    let(:email) { 'bob@someemail.com' }

    let(:account_attributes) do
      { email: email, organization: organization, person_attributes: {
        name: Faker::Name.name
      } }
    end

    let(:account) do
      Account.invite!(account_attributes, inviter)
    end

    let(:invite_params) do
      { account: {
        email: email,
        invitation_token: account.raw_invitation_token,
        password: 'password',
        password_confirmation: 'password',
        agreed_to_terms: true
      } }
    end

    it 'agrees to the terms' do
      put :update, params: invite_params
      expect(Account.last.agreed_to_terms?).to eq(true)
    end
  end
end
