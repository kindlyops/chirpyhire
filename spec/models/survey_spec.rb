require 'rails_helper'

RSpec.describe Survey, type: :model do

  describe "validation" do
    let(:survey) { build(:survey) }

    context "with multiple active questions" do
      context "each having a different priority" do
        before(:each) do
          survey.questions_attributes = [attributes_for(:document_question), attributes_for(:document_question)]
        end

        it "is passes validation" do
          survey.save
          expect(survey.valid?).to eq(true)
        end
      end

      context "with shared priority" do
        before(:each) do
          survey.questions_attributes = [attributes_for(:document_question, priority: 1), attributes_for(:document_question, priority: 1)]
        end

        it "fails validation" do
          survey.save
          expect(survey.valid?).to eq(false)
          expect(survey.errors).to include(:question_priorities)
        end
      end
    end
  end
end
