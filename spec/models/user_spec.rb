require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }

  describe "#subscribed_to?" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, organization: organization, user: user) }

      it "is true" do
        expect(user.subscribed_to?(organization)).to eq(true)
      end
    end

    context "without a subscription to the organization" do
      it "is false" do
        expect(user.subscribed_to?(organization)).to eq(false)
      end
    end
  end

  describe "#subscription_to" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, organization: organization, user: user) }

      it "returns the subscription" do
        expect(user.subscription_to(organization)).to eq(subscription)
      end
    end

    context "without a subscription to the organization" do
      it "is nil" do
        expect(user.subscription_to(organization)).to be_nil
      end
    end
  end

  describe "#subscribe_to" do
    context "with an existing subscription" do
      let!(:subscription) { create(:subscription, organization: organization, user: user) }

      it "soft deletes existing subscription" do
        expect {
          user.subscribe_to(organization)
        }.to change{subscription.reload.deleted?}.from(false).to(true)
      end
    end

    it "creates a new subscription" do
      expect{
        user.subscribe_to(organization)
      }.to change{user.subscriptions.with_deleted.count}.by(1)
    end
  end

  describe "#unsubscribed_from?" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, organization: organization, user: user) }

      it "is false" do
        expect(user.unsubscribed_from?(organization)).to eq(false)
      end
    end

    context "without a subscription to the organization" do
      it "is false" do
        expect(user.unsubscribed_from?(organization)).to eq(true)
      end
    end
  end

  describe "#unsubscribe_from" do
    context "with an existing subscription" do
      let!(:subscription) { create(:subscription, organization: organization, user: user) }

      it "soft deletes existing subscription" do
        expect {
          user.unsubscribe_from(organization)
        }.to change{subscription.reload.deleted?}.from(false).to(true)
      end
    end
  end

  describe "#name" do
    it "returns the first and last name" do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe "#phone_number" do
    context "without a phone number" do
      before(:each) do
        user.update(phone_number: nil)
      end

      it "is an empty string" do
        expect(user.phone_number).to eq("")
      end
    end
  end
end
