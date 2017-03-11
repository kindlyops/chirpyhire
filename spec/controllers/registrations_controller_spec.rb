require 'rails_helper'

RSpec.describe RegistrationsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:account]
  end

  let(:params) do
    { account: {
      email: 'test@chirpyhire.com',
      agreed_to_terms: true,
      name: 'Test User',
      password: 'password',
      organization_attributes: {
        name: 'Test Organization',
        location_attributes: {
          full_street_address: '2207 Broadway, New York, NY 10024'
        }
      },
    } }
  end

  describe '#create', vcr: { cassette_name: 'RegistrationsController#create' } do
    it 'sets the name of the account' do
      post :create, params: params

      expect(Account.last.name).to eq(params[:account][:name])
    end

    it 'makes a new account' do
      expect {
        post :create, params: params
      }.to change { Account.count }.by(1)
    end

    it 'makes a new organization' do
      expect {
        post :create, params: params
      }.to change { Organization.count }.by(1)
    end

    it 'assigns the new account as the recruiter' do
      post :create, params: params

      expect(Organization.last.recruiter).to eq(Account.last)
    end
  end
end
