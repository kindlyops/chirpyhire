require 'rails_helper'

RSpec.describe ProfileFeature, type: :model do

  let(:profile_features) { create_list(:profile_feature, 2) }
  let(:user) { create(:user) }

  describe ".next_for" do
    context "with user features for each profile feature" do
      before(:each) do

        profile_features.each do |feature|
          feature.user_features.create(user: user)
        end
      end

      it "is empty" do
        expect(ProfileFeature.next_for(user)).to eq(nil)
      end
    end

    context "without a user feature for one of the profile features" do
      before(:each) do
        feature = profile_features.first
        feature.user_features.create(user: user)
      end

      it "returns the profile feature" do
        expect(ProfileFeature.next_for(user)).to eq(profile_features.last)
      end
    end
  end

  describe "#question" do
    let(:document_profile_feature) { create(:profile_feature, format: :document) }
    let(:address_profile_feature) { create(:profile_feature, format: :address) }

    it "returns a question for the format" do
      expect(document_profile_feature.question).to eq("Please send a photo of your #{document_profile_feature.name}")
      expect(address_profile_feature.question).to eq("What is your street address and zipcode?")
    end
  end
end
