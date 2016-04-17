require 'rails_helper'

RSpec.describe Account, type: :model do

  let(:account) { create(:account) }

  context "#role" do
    it "is admin by default" do
      expect(account.role).to eq("admin")
    end
  end

  context ".roles" do
    let(:roles) { ["admin", "owner"] }
    it "is the appropriate roles" do
      expect(Account.roles.keys).to eq(roles)
    end
  end
end
