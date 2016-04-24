require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_owner) }
  let(:owner) { organization.accounts.first }

  describe "#ask", vcr: { cassette_name: "Organization_ask" } do
    let!(:organization) { create(:organization, :with_successful_phone) }
    let(:lead) { create(:lead, organization: organization) }
    let(:question) { create(:question, industry: organization.industry) }

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

  describe "#subscribed_leads" do
    context "without leads" do
      it "is empty" do
        expect(organization.subscribed_leads).to be_empty
      end
    end

    context "with leads" do
      let!(:subscribed_leads) { create_list(:lead, 2, :with_subscription, organization: organization) }
      let!(:unsubscribed_lead) { create(:lead, organization: organization) }

      context "with some unsubscribed" do
        it "is only the subscribed leads" do
          expect(organization.subscribed_leads).to eq(subscribed_leads)
        end
      end
    end
  end
end
