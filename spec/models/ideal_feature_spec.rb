require 'rails_helper'

RSpec.describe IdealFeature, type: :model do

  let(:ideal_features) { create_list(:ideal_feature, 2) }
  let(:candidate) { create(:candidate) }

  describe ".next_for" do
    context "with candidate features for each profile feature" do
      before(:each) do

        ideal_features.each do |feature|
          feature.candidate_features.create(candidate: candidate)
        end
      end

      it "is empty" do
        expect(IdealFeature.next_for(candidate)).to eq(nil)
      end
    end

    context "without a candidate feature for one of the profile features" do
      before(:each) do
        feature = ideal_features.first
        feature.candidate_features.create(candidate: candidate)
      end

      it "returns the profile feature" do
        expect(IdealFeature.next_for(candidate)).to eq(ideal_features.last)
      end
    end
  end

  describe "#question" do
    let(:document_ideal_feature) { create(:ideal_feature, format: :document) }
    let(:address_ideal_feature) { create(:ideal_feature, format: :address) }

    it "returns a question for the format" do
      expect(document_ideal_feature.question).to eq("Please send a photo of your #{document_ideal_feature.name}")
      expect(address_ideal_feature.question).to eq("What is your street address and zipcode?")
    end
  end
end
