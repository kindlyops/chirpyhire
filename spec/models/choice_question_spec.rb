require 'rails_helper'

RSpec.describe ChoiceQuestion, type: :model do
  describe ".extract" do
    let!(:organization) { create(:organization) }
    let!(:question) { create(:choice_question, survey: organization.create_survey) }
    let!(:message) { create(:message, body: "A) ") }

    let(:choice_hash) do
      {
        choice_option: "Live-in",
        child_class: "choice"
      }
    end

    before(:each) do
      question.choice_question_options.create(letter: "a", text: "Live-in")
    end

    it "returns a choice hash" do
      expect(ChoiceQuestion.extract(message, question)).to eq(choice_hash)
    end
  end

  let(:survey) { create(:survey) }

  describe "#question" do
    let(:choice_question) { create(:choice_question, text: "What is your availability?", survey: survey) }
    before(:each) do
      choice_question.choice_question_options.create(letter: "a", text: "Live-in")
      choice_question.choice_question_options.create(letter: "b", text: "Hourly")
      choice_question.choice_question_options.create(letter: "c", text: "Both")
    end

    let(:question) do
      <<-question
What is your availability?

a) Live-in
b) Hourly
c) Both


Please reply with just the letter a, b, or c.
  question
    end

    it "returns a question" do
      expect(choice_question.question).to eq(question)
    end
  end
end
