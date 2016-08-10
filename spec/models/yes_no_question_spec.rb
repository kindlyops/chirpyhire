require 'rails_helper'

RSpec.describe YesNoQuestion, type: :model do

  describe ".extract" do
    let(:message) { create(:message, body: "Y") }
    let(:question) { create(:yes_no_question) }
    let!(:inquiry) { create(:inquiry, question: question) }

    let(:yes_hash) do
      {
        yes_no_option: "Yes",
        child_class: "yes_no"
      }
    end

    it "extracts the appropriate hash" do
      expect(YesNoQuestion.extract(message, inquiry)).to eq(yes_hash)
    end
  end

  describe "instance methods" do
    let!(:yes_no_question) { create(:yes_no_question, text: "Can you drive?") }

    describe "#formatted_text" do
      let(:question) do
        <<-question
Can you drive?

Please reply with just Yes or No.
    question
      end

      it "returns a question" do
        expect(yes_no_question.formatted_text).to eq(question)
      end
    end
  end
end
