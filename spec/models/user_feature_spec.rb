require 'rails_helper'

RSpec.describe UserFeature, type: :model do
  let(:user_feature) { create(:user_feature) }
  let(:user) { user_feature.user }

  describe "#inquire" do
    it "creates a message" do
      expect{
        user_feature.inquire
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        user_feature.inquire
      }.to change{user_feature.inquiries.count}.by(1)
    end
  end
end
