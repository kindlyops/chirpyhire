require 'rails_helper'

RSpec.describe QuestionAnswerDecorator do
  let(:model) { create(:question) }
  let(:question) { QuestionAnswerDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(question.title).to eq("Answers a question")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(question.subtitle).to eq("Candidate answers a screening question via text message.")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(question.icon_class).to eq("fa-reply")
    end
  end
end
