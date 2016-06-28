require 'rails_helper'

RSpec.describe CandidateScreenDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateScreenDecorator.new(model) }
  let(:user) { candidate.user }

  describe "#user" do
    it "is decorated" do
      expect(user).to be_decorated_with UserDecorator
    end
  end

  describe "#color" do
    it "is complete" do
      expect(candidate.color).to eq("complete")
    end
  end

  describe "#body" do
    it "is a screen message" do
      expect(candidate.body).to eq("Woohoo! #{user.from_short}'s profile is completed. Please review at your convenience.")
    end
  end

  describe "#icon_class" do
    it "is the subscribe hand" do
      expect(candidate.icon_class).to eq("fa-star")
    end
  end

  describe "#subtitle" do
    it "is the screen subtitle" do
      expect(candidate.subtitle).to eq("#{user.from_short} has answered all screening questions")
    end
  end

  describe "#attachments" do
    it "is an empty array" do
      expect(candidate.attachments).to eq([])
    end
  end
end
