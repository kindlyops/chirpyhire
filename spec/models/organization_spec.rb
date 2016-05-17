require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_owner) }
  let(:owner) { organization.accounts.first }

  describe ".for" do
    let(:organization) { create(:organization, :with_phone) }
    it "looks up an organization by phone number" do
      expect(Organization.for(phone: organization.phone_number)).to eq(organization)
    end
  end

  describe "#send_message" do
    let(:organization) { create(:organization, :with_successful_phone) }
    let(:user) { create(:user, organization: organization) }

    it "sends the sms message" do
      expect{
        organization.send_message(to: user.phone_number, body: "Test")
      }.to change{FakeMessaging.messages.count}.by(1)
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

  describe "#subscribed_candidates" do
    context "without candidates" do
      it "is empty" do
        expect(organization.subscribed_candidates).to be_empty
      end
    end

    context "with candidates" do
      let!(:users) { create_list(:user, 2, organization: organization) }

      let!(:subscribed_candidates) do
        [create(:candidate, :with_subscription, user: users.first),
        create(:candidate, :with_subscription, user: users.last)]
      end

      let!(:unsubscribed_candidate) { create(:candidate, user: create(:user, organization: organization)) }

      context "with some unsubscribed" do
        it "is only the subscribed candidates" do
          expect(organization.subscribed_candidates).to eq(subscribed_candidates)
        end
      end
    end
  end
end
