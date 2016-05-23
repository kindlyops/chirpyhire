require 'rails_helper'

RSpec.describe QuestionDecorator do
  let(:model) { create(:question) }
  let(:question) { QuestionDecorator.new(model) }

  describe "#title" do
    it "is the right title" do
      expect(question.title).to eq("Ask a question")
    end
  end

  describe "#subtitle" do
    it "is the right subtitle" do
      expect(question.subtitle).to eq("Asks candidate a screening question via text message.")
    end
  end

  describe "#icon_class" do
    it "is the right icon class" do
      expect(question.icon_class).to eq("fa-question")
    end
  end
end
