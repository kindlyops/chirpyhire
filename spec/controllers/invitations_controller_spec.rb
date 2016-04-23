require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let!(:organization) { create(:organization, :with_owner) }
  let(:inviter) { organization.accounts.first }

  let(:invite_params) do
    { account: { email: "bob@example.com" } }
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:account]
    sign_in(inviter)
  end

  describe "#create" do
    it "ties the new account to the inviter's organization" do
      expect {
        post :create, invite_params
      }.to change{organization.accounts.reload.count}.by(1)
    end
  end
end
