require 'rails_helper'

RSpec.describe Choice, type: :model do
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
      expect(Choice.extract(message, question)).to eq(choice_hash)
    end
  end
end
