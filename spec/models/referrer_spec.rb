require 'rails_helper'

RSpec.describe Referrer, type: :model do
  let(:organization) { create(:organization, :with_account) }
  let(:account) { organization.accounts.first }
  let(:job) { create(:job, account: account) }

  let(:referrer) { create(:referrer) }

  describe "#last_referral" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, referrer: referrer, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: referrer) }

      it "returns the referral created last" do
        expect(referrer.last_referral).to eq(last_referral)
      end
    end

    context "without referrals" do
      it "is a NullReferral" do
        expect(referrer.last_referral).to be_a(NullReferral)
      end
    end
  end

  describe "#last_referred" do
    context "with candidates" do
      let!(:old_referral) { create(:referral, referrer: referrer, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: referrer) }

      it "returns the referrer created last" do
        expect(referrer.last_referred).to eq(last_referral.candidate)
      end
    end

    context "without candidates" do
      it "is a NullCandidate" do
        expect(referrer.last_referred).to be_a(NullCandidate)
      end
    end
  end

  describe "#last_referral_at" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, referrer: referrer, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: referrer) }

      it "returns the last referral's created_at" do
        expect(referrer.last_referral_at).to eq(last_referral.created_at)
      end
    end

    context "without referrals" do
      it "is nil" do
        expect(referrer.last_referral_at).to be_nil
      end
    end
  end

  describe "#last_referral_name" do
    context "with candidates" do
      let!(:old_referral) { create(:referral, referrer: referrer, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: referrer) }

      it "returns the last referrer's name" do
        expect(referrer.last_referral_name).to eq(last_referral.candidate.name)
      end
    end

    context "without candidates" do
      it "is nil" do
        expect(referrer.last_referral_name).to be_blank
      end
    end
  end
end
