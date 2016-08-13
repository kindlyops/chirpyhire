require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:account]
  end

  describe "#create", vcr: { cassette_name: "RegistrationsController-create" } do
    let(:email) { "bob@someemail.com" }
    let(:account_params) do
      { account: {
        email: email,
        password: "password",
        password_confirmation: "password",
        agreed_to_terms: true,
        user_attributes: {
          first_name: "Bob",
          last_name: "Bobson",
          organization_attributes: {
            name: "Home Instead",
            location_attributes: {
              full_street_address: "1000 E. Market St. 22902"
            }
          }
        }
      }}
    end

    it "ties the organization and user to the account" do
      post :create, params: account_params
      account = Account.find_by(email: account_params[:account][:email])
      expect(account.organization.present?).to eq(true)
      expect(account.user.present?).to eq(true)
    end

    it "creates an account" do
      expect {
        post :create, params: account_params
      }.to change{Account.count}.by(1)
    end

    it "agrees to the terms" do
      post :create, params: account_params
      expect(Account.last.agreed_to_terms?).to eq(true)
    end

    it "creates an organization" do
      expect {
        post :create, params: account_params
      }.to change{Organization.count}.by(1)
    end

    it "creates a user" do
      expect {
        post :create, params: account_params
      }.to change{User.count}.by(1)
    end
  end
end
