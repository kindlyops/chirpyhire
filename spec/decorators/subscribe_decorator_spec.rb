require 'rails_helper'

RSpec.describe SubscribeDecorator do
  let(:model) { create(:trigger, event: "subscribe") }
  let(:trigger) { SubscribeDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(trigger.title).to eq("Subscribes")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(trigger.subtitle).to eq("Candidate opts-in to receiving communications via text message.")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(trigger.icon_class).to eq("fa-hand-paper-o")
    end
  end
end
