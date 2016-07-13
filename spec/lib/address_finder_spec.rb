require 'rails_helper'

RSpec.describe "AddressFinder" do
  let(:finder) { AddressFinder.new(address) }

  context "with valid address", vcr: { cassette_name: "AddressFinder-valid-address" } do
    let(:address) { "4059 Mt Lee Dr 90068" }

    describe "#found?" do
      it "is true" do
        expect(finder.found?).to eq(true)
      end
    end

    describe "#address" do
      it do
        expect(finder.address).to eq("Mount Lee Drive, McNeil, CA 90068, United States of America")
      end
    end

    describe "#latitude" do
      it do
        expect(finder.latitude).to eq(34.1355329)
      end
    end

    describe "#longitude" do
      it do
        expect(finder.longitude).to eq(-118.317814)
      end
    end

    describe "#country" do
      it do
        expect(finder.country).to eq("United States of America")
      end
    end

    describe "#city" do
      it do
        expect(finder.city).to eq("McNeil")
      end
    end

    describe "#postal_code" do
      it do
        expect(finder.postal_code).to eq("90068")
      end
    end
  end

  context "with invalid address" do
    context "no zipcode" do
      let(:address) { "4059 Mt Lee Dr" }

      describe "#found?" do
        it "is false" do
          expect(finder.found?).to eq(false)
        end
      end
    end

    context "no street address" do
      let(:address) { "90068" }

      describe "#found?" do
        it "is false" do
          expect(finder.found?).to eq(false)
        end
      end
    end
  end
end
