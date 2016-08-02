require 'rails_helper'

RSpec.describe AddressQuestion, type: :model do
  let(:survey) { create(:survey) }
  let(:question) { create(:address_question, survey: survey) }

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
      expect(AddressQuestion.extract(message, double())).to eq(address_hash)
    end
  end

  describe "#has_geofence?" do
    context "with geofence" do
      before(:each) do
        create(:address_question_option, question: question)
      end

      it "is true" do
        expect(question.has_geofence?).to eq(true)
      end
    end

    context "without geofence" do
      it "is false" do
        expect(question.has_geofence?).to eq(false)
      end
    end
  end

  describe "#distance_in_miles" do
    context "with geofence" do
      let!(:address_question_option) { create(:address_question_option, question: question) }

      it "is the distance" do
        expect(question.distance_in_miles).to eq(address_question_option.distance)
      end
    end

    context "without geofence" do
      it "is nil" do
        expect(question.distance_in_miles).to eq(nil)
      end
    end
  end

  describe "#coordinates" do
    context "with geofence" do
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }
      let!(:address_question_option) { create(:address_question_option, latitude: latitude, longitude: longitude, question: question) }

      it "is an array of latitude and longitude" do
        expect(question.coordinates).to eq([latitude, longitude])
      end
    end

    context "without geofence" do
      it "is an empty array" do
        expect(question.coordinates).to eq([])
      end
    end
  end
end
