require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:account]
  end

  describe "#create" do
    let(:account_params) do
      { account: {
        email: "bob@someemail.com",
        password: "password",
        password_confirmation: "password",
        user_attributes: {
          first_name: "Bob",
          last_name: "Bobson"
        },
        organization_attributes: {
          name: "Home Instead"
        }
      } }
    end

    it "creates an account" do
      expect {
        post :create, account_params
      }.to change{Account.count}.by(1)
    end

    it "creates an organization" do
      expect {
        post :create, account_params
      }.to change{Organization.count}.by(1)
    end

    it "creates a user" do
      expect {
        post :create, account_params
      }.to change{User.count}.by(1)
    end
  end
end
