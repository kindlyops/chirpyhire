require 'rails_helper'

RSpec.describe Address, type: :model do
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
      expect(Address.extract(message)).to eq(address_hash)
    end
  end
end
