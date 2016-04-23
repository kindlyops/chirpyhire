require 'rails_helper'

RSpec.describe Account, type: :model do

  let(:account) { create(:account) }

  describe "#role" do
    it "is admin by default" do
      expect(account.role).to eq("admin")
    end
  end

  describe ".roles" do
    let(:roles) { ["admin", "owner"] }
    it "is the appropriate roles" do
      expect(Account.roles.keys).to eq(roles)
    end
  end

  describe "#send_reset_password_instructions" do
    context "with an invitation token" do
      let(:account) { create(:account, invitation_token: "123") }
      it "does not send a password reset email" do
        expect {
          account.send_reset_password_instructions
        }.not_to change {ActionMailer::Base.deliveries.count}
      end
    end
  end
end
