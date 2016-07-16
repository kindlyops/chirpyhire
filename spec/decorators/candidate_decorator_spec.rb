require 'rails_helper'

RSpec.describe CandidateDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateDecorator.new(model) }

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

  describe "#choices" do
    context "with choices" do
      let(:persona_feature) { create(:persona_feature, :choice, candidate_persona: model.organization.candidate_persona) }
      let(:option) { "Live-in" }
      let(:choice_properties) do
        {
          choice_option: option,
          child_class: "choice"
        }
      end

      before(:each) do
        create(:candidate_feature, candidate: model, properties: choice_properties, persona_feature: persona_feature)
      end

      it "is an array of choices" do
        expect(candidate.choices.first.option).to eq(option)
        expect(candidate.choices.first.category).to eq(persona_feature.name)
      end
    end

    context "without choices" do
      it "is an empty array" do
        expect(candidate.choices).to eq([])
      end
    end
  end

  describe "#documents" do
    context "with documents" do
      let(:persona_feature) { create(:persona_feature, candidate_persona: model.organization.candidate_persona) }
      let(:url0) { "http://www.freedigitalphotos.net/images/img/homepage/87357.jpg" }
      let(:document_properties) do
        {
          url0: url0,
          child_class: "document"
        }
      end

      before(:each) do
        create(:candidate_feature, candidate: model, properties: document_properties, persona_feature: persona_feature)
      end

      it "is an array of documents" do
        expect(candidate.documents.first.first_page).to eq(url0)
        expect(candidate.documents.first.category).to eq(persona_feature.name)
      end
    end

    context "without documents" do
      it "is an empty array" do
        expect(candidate.documents).to eq([])
      end
    end
  end
end
