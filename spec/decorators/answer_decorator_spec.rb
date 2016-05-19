require 'rails_helper'

RSpec.describe AnswerDecorator do
  let(:model) { create(:trigger, event: "answer") }
  let(:trigger) { AnswerDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(trigger.title).to eq("Answers a question")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(trigger.subtitle).to eq("Candidate answers a screening question via text message.")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(trigger.icon_class).to eq("fa-reply")
    end
  end
end
