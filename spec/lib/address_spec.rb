require 'rails_helper'

RSpec.describe Address do
  let(:address_candidate_feature) { create(:candidate_feature, :address) }
  let(:address) { Address.new(address_candidate_feature) }
  describe "#coordinates" do

    context "with latitude and longitude" do
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }

      before(:each) do
        address_candidate_feature.update(properties: { latitude: latitude, longitude: longitude })
      end

      it "is an array of latitude and longitude" do
        expect(address.coordinates).to eq([latitude, longitude])
      end
    end

    context "without latitude and longitude" do
      before(:each) do
        address_candidate_feature.update(properties: { })
      end

      it "is an empty array" do
        expect(address.coordinates).to eq([])
      end
    end
  end
end
