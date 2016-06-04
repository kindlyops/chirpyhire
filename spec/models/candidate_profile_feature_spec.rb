require 'rails_helper'

RSpec.describe CandidateProfileFeature, type: :model do
  let(:candidate_profile_feature) { create(:candidate_profile_feature) }
  let(:user) { candidate_profile_feature.user }

  describe "#inquire" do
    it "creates a message" do
      expect{
        candidate_profile_feature.inquire
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        candidate_profile_feature.inquire
      }.to change{candidate_profile_feature.inquiries.count}.by(1)
    end
  end
end
