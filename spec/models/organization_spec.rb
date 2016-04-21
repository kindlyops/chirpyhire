require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_owner) }
  let(:owner) { organization.accounts.first }

  describe "#ask", vcr: { cassette_name: "Organization_ask" } do
    let!(:organization) { create(:organization, :with_successful_phone) }
    let(:lead) { create(:lead, organization: organization) }
    let(:question) { create(:question, organization: organization) }

    it "creates a message" do
      expect {
        organization.ask(lead, question)
      }.to change{organization.messages.count}.by(1)
    end
  end

  describe "#owner" do
    it "returns an account with the owner role" do
      expect(organization.owner).to eq(owner)
    end
  end

  describe "#owner_first_name" do
    it "returns the owner's first name" do
      expect(organization.owner_first_name).to eq(owner.first_name)
    end
  end
end
