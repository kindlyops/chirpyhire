require 'rails_helper'

RSpec.describe JobQuestion, type: :model do
  let(:job_question) { create(:job_question) }

  describe "#starting_search?" do
    context "with previous question" do
      before(:each) do
        job_question.update(previous_question: create(:question))
      end

      it "is false" do
        expect(job_question.starting_search?).to eq(false)
      end
    end

    context "without previous question" do
      it "is true" do
        expect(job_question.starting_search?).to eq(true)
      end
    end
  end
end
