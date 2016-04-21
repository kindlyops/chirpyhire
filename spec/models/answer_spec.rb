require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe ".recent" do
    context "with answers created in the last 7 days" do
      let!(:recent_answers) { create_list(:answer, 3) }
      let!(:old_answers) { create_list(:answer, 2, created_at: 10.days.ago) }

      it "is the recent answers" do
        expect(Answer.recent).to eq(recent_answers)
      end
    end

    context "with no answers created in the last 7 days" do
      it "is empty" do
        expect(Answer.recent).to be_empty
      end
    end
  end

  describe ".positive" do
    context "with positive answers" do
      let!(:positive_answers) { create_list(:answer, 3, body: "Y") }
      let!(:negative_answers) { create_list(:answer, 2, body: "N") }

      it "is the recent answers" do
        expect(Answer.positive).to eq(positive_answers)
      end
    end

    context "with no positive answers" do
      let!(:negative_answers) { create_list(:answer, 2, body: "N") }

      it "is empty" do
        expect(Answer.positive).to be_empty
      end
    end
  end

  describe ".negative" do
    context "with negative answers" do
      let!(:positive_answers) { create_list(:answer, 3, body: "Y") }
      let!(:negative_answers) { create_list(:answer, 2, body: "N") }

      it "is the recent answers" do
        expect(Answer.negative).to eq(negative_answers)
      end
    end

    context "with no negative answers" do
      let!(:positive_answers) { create_list(:answer, 3, body: "Y") }

      it "is empty" do
        expect(Answer.negative).to be_empty
      end
    end
  end

  describe ".to" do
    let!(:question) { create(:question) }
    context "with answers to the question" do
      let!(:answers_to_question) { create_list(:answer, 2, question: question) }
      let!(:other_answer) { create(:answer) }

      it "is the answers to the question" do
        expect(Answer.to(question)).to eq(answers_to_question)
      end
    end

    context "without answers to the question" do
      it "is empty" do
        expect(Answer.to(question)).to be_empty
      end
    end
  end
end
