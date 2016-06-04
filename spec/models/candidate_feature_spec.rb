require 'rails_helper'

RSpec.describe CandidateFeature, type: :model do
  let(:candidate_feature) { create(:candidate_feature) }

  describe "#inquire" do
    it "creates a message" do
      expect{
        candidate_feature.inquire
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        candidate_feature.inquire
      }.to change{candidate_feature.inquiries.count}.by(1)
    end
  end
end
