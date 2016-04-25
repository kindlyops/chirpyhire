require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_owner) }
  let(:owner) { organization.accounts.first }

  describe "#ask", vcr: { cassette_name: "Organization_ask" } do
    let!(:organization) { create(:organization, :with_successful_phone, :with_question) }
    let(:lead) { create(:lead, organization: organization) }
    let(:question) { organization.questions.first }
    let(:inquiry) { lead.inquiries.build(question: question) }
    it "creates a message" do
      expect {
        organization.ask(inquiry)
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

        context "with some of the subscribed leads not having a phone number" do
          let(:subscribed_lead_without_phone_number) do
            lead = subscribed_leads.sample
            lead.user.update(phone_number: nil)
            lead
          end

          it "is only the subscribed leads with a phone number" do
            expect(organization.subscribed_leads).not_to include(subscribed_lead_without_phone_number)
          end
        end
      end
    end
  end
end
