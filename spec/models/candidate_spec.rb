require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:organization) { create(:organization, :with_account, ) }
  let(:account) { organization.accounts.first }

  let(:candidate) { create(:candidate) }
  let(:user) { candidate.user }

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

  describe "#last_referral_created_at" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referral's created_at" do
        expect(candidate.last_referral_created_at).to eq(last_referral.created_at)
      end
    end

    context "without referrals" do
      it "is nil" do
        expect(candidate.last_referral_created_at).to be_nil
      end
    end
  end

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
end
