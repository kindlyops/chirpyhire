require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:organization) { create(:organization, :with_account, ) }
  let(:account) { organization.accounts.first }

  let(:candidate) { create(:candidate) }
  let(:user) { candidate.user }

  describe "#last_referrer" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the referrer created last" do
        expect(candidate.last_referrer).to eq(last_referral.referrer)
      end
    end

    context "without referrers" do
      it "is a NullReferrer" do
        expect(candidate.last_referrer).to be_a(NullReferrer)
      end
    end
  end

  describe "#last_referral" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the referral created last" do
        expect(candidate.last_referral).to eq(last_referral)
      end
    end

    context "without referrals" do
      it "is a NullReferral" do
        expect(candidate.last_referral).to be_a(NullReferral)
      end
    end
  end

  describe "#last_referred_at" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referral's created_at" do
        expect(candidate.last_referred_at).to eq(last_referral.created_at)
      end
    end

    context "without referrals" do
      it "is nil" do
        expect(candidate.last_referred_at).to be_nil
      end
    end
  end

  describe "#last_referrer_name" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referrer's name" do
        expect(candidate.last_referrer_name).to eq(last_referral.referrer.name)
      end
    end

    context "without referrers" do
      it "is nil" do
        expect(candidate.last_referrer_name).to be_blank
      end
    end
  end

  describe "#last_referrer_phone_number" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referrer's phone number" do
        expect(candidate.last_referrer_phone_number).to eq(last_referral.referrer.phone_number)
      end
    end

    context "without referrers" do
      it "is nil" do
        expect(candidate.last_referrer_phone_number).to be_blank
      end
    end
  end

  describe "#subscribed?" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, candidate: candidate) }

      it "is true" do
        expect(candidate.subscribed?).to eq(true)
      end
    end

    context "without a subscription to the organization" do
      it "is false" do
        expect(candidate.subscribed?).to eq(false)
      end
    end
  end

  describe "#subscription" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, candidate: candidate) }

      it "returns the subscription" do
        expect(candidate.subscription).to eq(subscription)
      end
    end

    context "without a subscription to the organization" do
      it "is nil" do
        expect(candidate.subscription).to be_nil
      end
    end
  end

  describe "#subscribe" do
    context "with an existing subscription" do
      let!(:subscription) { create(:subscription, candidate: candidate) }

      it "soft deletes existing subscription" do
        expect {
          candidate.subscribe
        }.to change{subscription.reload.deleted?}.from(false).to(true)
      end
    end

    it "creates a new subscription" do
      expect{
        candidate.subscribe
      }.to change{candidate.subscriptions.with_deleted.count}.by(1)
    end
  end

  describe "#unsubscribed?" do
    context "with a subscription to the organization" do
      let!(:subscription) { create(:subscription, candidate: candidate) }

      it "is false" do
        expect(candidate.unsubscribed?).to eq(false)
      end
    end

    context "without a subscription to the organization" do
      it "is false" do
        expect(candidate.unsubscribed?).to eq(true)
      end
    end
  end

  describe "#unsubscribe" do
    context "with an existing subscription" do
      let!(:subscription) { create(:subscription, candidate: candidate) }

      it "soft deletes existing subscription" do
        expect {
          candidate.unsubscribe
        }.to change{subscription.reload.deleted?}.from(false).to(true)
      end
    end
  end
end
