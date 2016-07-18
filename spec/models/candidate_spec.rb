require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:candidate) { create(:candidate) }

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
        create(:candidate_feature, candidate: candidate, properties: address_properties)
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
