require 'rails_helper'

RSpec.describe ChoiceQuestion, type: :model do
  let(:survey) { create(:survey) }

  describe "#question" do
    let(:choice_question) { create(:question, :choice, survey: survey) }
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
