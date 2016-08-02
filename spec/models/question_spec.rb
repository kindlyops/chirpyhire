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

    context "choice question" do
      let(:question) { create(:choice_question, text: "What is your availability?", survey: survey) }
      before(:each) do
        question.choice_question_options.create(letter: "a", text: "Live-in")
        question.choice_question_options.create(letter: "b", text: "Hourly")
        question.choice_question_options.create(letter: "c", text: "Both")
      end

      let(:question_text) do
        <<-question
What is your availability?

a) Live-in
b) Hourly
c) Both


Please reply with just the letter a, b, or c.
    question
      end

      it "has the right body" do
        question.inquire(candidate.user)
        expect(Message.last.body).to eq(question_text)
      end
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
