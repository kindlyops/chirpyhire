require 'rails_helper'

RSpec.describe Question, type: :model do

  let(:candidate) { create(:candidate) }
  let(:survey) { candidate.organization.create_survey }
  let(:question) { create(:question, survey: survey) }

  describe "#inquire" do
    it "creates a message" do
      expect{
        question.inquire(candidate.user)
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        question.inquire(candidate.user)
      }.to change{question.inquiries.count}.by(1)
    end
  end

  describe "#question" do
    context "document" do
      let(:text) { "Please send a photo of your TB Test" }
      let(:question) { create(:question, text: text, survey: survey) }
      it "is the text of the question" do
        expect(question.question).to eq(text)
      end
    end
  end
end
