require 'rails_helper'

RSpec.describe PersonaFeature, type: :model do

  let(:candidate) { create(:candidate) }
  let(:candidate_persona) { candidate.organization.candidate_persona }
  let(:persona_feature) { create(:persona_feature, candidate_persona: candidate_persona) }

  describe "#inquire" do
    it "creates a message" do
      expect{
        persona_feature.inquire(candidate.user)
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        persona_feature.inquire(candidate.user)
      }.to change{persona_feature.inquiries.count}.by(1)
    end
  end

  describe "#has_geofence?" do
    context "document or choice" do
      let(:document_persona_feature) { create(:persona_feature, text: "Test Text", candidate_persona: candidate_persona, format: :document) }
      let(:choice_persona_feature) { create(:persona_feature, :choice, candidate_persona: candidate_persona) }

      it "is false" do
        expect(document_persona_feature.has_geofence?).to eq(false)
        expect(choice_persona_feature.has_geofence?).to eq(false)
      end
    end

    context "address" do
      let(:address_persona_feature) { create(:persona_feature,
                                             text: "Test Text",
                                             candidate_persona: candidate_persona,
                                             format: :address) }

      context "with distance address option" do
        before(:each) do
          address_persona_feature.update(properties: { distance: 20 })
        end

        it "is true" do
          expect(address_persona_feature.has_geofence?).to eq(true)
        end
      end

      it "is false" do
        expect(address_persona_feature.has_geofence?).to eq(false)
      end
    end
  end

  describe "#distance_in_miles" do
    context "with distance" do
      let(:distance) { 20 }

      before(:each) do
        persona_feature.update(properties: { distance: distance })
      end
      it "returns the distance" do
        expect(persona_feature.distance_in_miles).to eq(distance)
      end
    end

    it "is nil" do
      expect(persona_feature.distance_in_miles).to eq(nil)
    end
  end

  describe "#coordinates" do
    let(:address_persona_feature) { create(:persona_feature, text: "text", candidate_persona: candidate_persona, format: :address) }

    context "with latitude and longitude" do
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }

      before(:each) do
        address_persona_feature.update(properties: { latitude: latitude, longitude: longitude })
      end

      it "is an array of latitude and longitude" do
        expect(address_persona_feature.coordinates).to eq([latitude, longitude])
      end
    end

    context "without latitude and longitude" do
      it "is an empty array" do
        expect(address_persona_feature.coordinates).to eq([])
      end
    end
  end

  describe "#question" do
    context "document" do
      let(:text) { "Please send a photo of your TB Test" }
      let(:document_persona_feature) { create(:persona_feature, text: text, candidate_persona: candidate_persona, format: :document) }
      it "returns a question for the format" do
        expect(document_persona_feature.question).to eq(text)
      end
    end

    context "address" do
      let(:text) { "What is your street address and zipcode?" }
      let(:address_persona_feature) { create(:persona_feature, text: text, candidate_persona: candidate_persona, format: :address) }
      it "returns a question for the format" do
        expect(address_persona_feature.question).to eq(text)
      end
    end

    context "choice" do
      let(:choice_persona_feature) { create(:persona_feature, :choice, candidate_persona: candidate_persona) }
      let(:question) do
        <<-question
What is your availability?

a) Live-in
b) Hourly
c) Both


Please reply with just the letter a, b, or c.
question
      end

      it "returns a question for the format" do
        expect(choice_persona_feature.question).to eq(question)
      end
    end
  end
end
