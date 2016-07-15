require 'rails_helper'

RSpec.describe ReferrerDecorator do
  let(:model) { create(:referrer) }
  let(:referrer) { ReferrerDecorator.new(model) }

  describe "#last_referral_created_at" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, referrer: model, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: model) }

      it "returns the last referral's created_at" do
        expect(referrer.last_referral_created_at).to be_within(0.1).of(last_referral.created_at)
      end
    end

    context "without referrals" do
      it "is nil" do
        expect(referrer.last_referral_created_at).to be_nil
      end
    end
  end

  describe "#last_referred_name" do
    context "with candidates" do
      let!(:old_referral) { create(:referral, referrer: model, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, referrer: model) }

      let(:user) { last_referral.candidate.user.decorate }

      it "returns the last referrer's name" do
        expect(referrer.last_referred_name).to eq(user.name)
      end
    end

    context "without candidates" do
      it "is nil" do
        expect(referrer.last_referred_name).to be_blank
      end
    end
  end
end
