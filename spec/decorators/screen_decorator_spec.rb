require 'rails_helper'

RSpec.describe ScreenDecorator do
  let(:model) { create(:trigger, event: "screen") }
  let(:trigger) { ScreenDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(trigger.title).to eq("Screened")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(trigger.subtitle).to eq("Candidate answers all screening questions")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(trigger.icon_class).to eq("fa-reply")
    end
  end
end
