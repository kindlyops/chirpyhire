require 'rails_helper'

RSpec.describe CandidateDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateDecorator.new(model) }


  describe "#last_referrer_name" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }
      let(:referrer_name) { last_referral.referrer.decorate.name }

      it "returns the last referrer's name" do
        expect(candidate.last_referrer_name).to eq(referrer_name)
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

  describe "#address" do
    context "with an address candidate feature" do
      let(:latitude) { "12.123456" }
      let(:longitude) { "34.156788" }
      let(:address_properties) do
        {
          address: "123 Main St. 30309",
          latitude: latitude,
          longitude: longitude,
          child_class: "address"
        }
      end

      before(:each) do
        create(:candidate_feature, candidate: model, properties: address_properties)
      end

      it "has a latitude" do
        expect(candidate.address.latitude).to eq(latitude)
      end

      it "has a longitude" do
        expect(candidate.address.longitude).to eq(longitude)
      end
    end

    context "without an address candidate feature" do
      it "does not have a latitude" do
        expect(candidate.address.latitude).to eq(nil)
      end

      it "does not have a longitude" do
        expect(candidate.address.latitude).to eq(nil)
      end
    end
  end
end
