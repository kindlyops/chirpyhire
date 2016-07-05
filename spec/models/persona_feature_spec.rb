require 'rails_helper'

RSpec.describe PersonaFeature, type: :model do

  let(:candidate) { create(:candidate) }
  let(:persona_features) { create_list(:persona_feature, 2, candidate_persona: candidate.candidate_persona) }

  describe ".next_for" do
    context "with candidate features for each profile feature" do
      before(:each) do

        persona_features.each do |feature|
          feature.candidate_features.create(candidate: candidate)
        end
      end

      it "is empty" do
        expect(PersonaFeature.next_for(candidate)).to eq(nil)
      end
    end

    context "without a candidate feature for one of the profile features" do
      before(:each) do
        feature = persona_features.first
        feature.candidate_features.create(candidate: candidate)
      end

      it "returns the profile feature" do
        expect(PersonaFeature.next_for(candidate)).to eq(persona_features.last)
      end
    end
  end

  describe "#question" do
    context "document" do
      let(:document_persona_feature) { create(:persona_feature, candidate_persona: candidate.candidate_persona, format: :document) }
      it "returns a question for the format" do
        expect(document_persona_feature.question).to eq("Please send a photo of your #{document_persona_feature.name}")
      end
    end

    context "address" do
      let(:address_persona_feature) { create(:persona_feature, candidate_persona: candidate.candidate_persona, format: :address) }
      it "returns a question for the format" do
        expect(address_persona_feature.question).to eq("What is your street address and zipcode?")
      end
    end

    context "choice" do
      let(:choice_persona_feature) { create(:persona_feature, :choice, candidate_persona: candidate.candidate_persona) }
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
