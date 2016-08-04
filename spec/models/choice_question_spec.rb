require 'rails_helper'

RSpec.describe ChoiceQuestion, type: :model do
  let!(:organization) { create(:organization) }
  let!(:message) { create(:message, body: "A) ") }
  let(:survey) { create(:survey) }

  let(:choice_hash) do
    {
      choice_option: "Live-in",
      child_class: "choice"
    }
  end

  let!(:choice_question) { create(:choice_question, text: "What is your availability?", survey: survey) }
  let!(:options) do
    [
      choice_question.choice_question_options.create(letter: "a", text: "Live-in"),
      choice_question.choice_question_options.create(letter: "b", text: "Hourly"),
      choice_question.choice_question_options.create(letter: "c", text: "Both")
    ]
  end

  describe ".extract" do
    it "returns a choice hash" do
      expect(ChoiceQuestion.extract(message, choice_question)).to eq(choice_hash)
    end
  end


  describe "#in_memory_sorted_options" do
    it "sorts the options by letter" do
      expect(choice_question.in_memory_sorted_options.map(&:letter)).to eq(%w(a b c))
    end
  end

  describe "#question" do
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
