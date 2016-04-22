require 'rails_helper'

RSpec.describe SearchQuestion, type: :model do
  let(:search_question) { create(:search_question) }

  describe "#starting_search?" do
    context "with previous question" do
      before(:each) do
        search_question.update(previous_question: create(:question))
      end

      it "is false" do
        expect(search_question.starting_search?).to eq(false)
      end
    end

    context "without previous question" do
      it "is true" do
        expect(search_question.starting_search?).to eq(true)
      end
    end
  end
end
