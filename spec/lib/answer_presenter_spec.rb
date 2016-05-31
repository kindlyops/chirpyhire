require 'rails_helper'

RSpec.describe AnswerPresenter do
  let(:trigger) { AnswerPresenter.new }

  describe "#title" do
    it "is the right title" do
      expect(trigger.title).to eq("Answer")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(trigger.subtitle).to eq("Candidate responded with a valid answer")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(trigger.icon_class).to eq("fa-reply")
    end
  end
end
