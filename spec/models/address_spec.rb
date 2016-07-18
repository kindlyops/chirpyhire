require 'rails_helper'

RSpec.describe Address, type: :model do
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

  describe ".extract" do
    let(:address) do
     FakeAddress.new(
      "1000 East Market Street, Charlottesville, VA, USA",
      38.028531,
      -78.473088,
      "USA",
      "Charlottesville",
      "22902")
    end

    let(:message) { create(:message) }

    let(:address_hash) do
      { city: "Charlottesville",
        address: "1000 East Market Street, Charlottesville, VA, USA",
        country: "USA",
        latitude: 38.028531,
        longitude: -78.473088,
        postal_code: "22902",
        child_class: "address"}
    end

    before(:each) do
      allow(message).to receive(:address).and_return(address)
    end

    it "returns an address hash" do
      expect(Address.extract(message, double())).to eq(address_hash)
    end
  end
end
