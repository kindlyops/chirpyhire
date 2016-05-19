require 'rails_helper'

RSpec.describe CandidateSubscribeDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateSubscribeDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(candidate.title).to eq("Subscribes")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(candidate.subtitle).to eq("Candidate opts-in to receiving communications via text message.")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(candidate.icon_class).to eq("fa-hand-paper-o")
    end
  end
end
