require 'rails_helper'

RSpec.describe Action, type: :model do
  describe "#actionable" do
    context "with a question" do
      let(:action) { create(:action, :with_question) }
      let(:question) { action.question }
      it "is the question" do
        expect(action.actionable).to eq(question)
      end
    end

    context "with a notice" do
      let(:action) { create(:action, :with_notice) }
      let(:notice) { action.notice }

      it "is the notice" do
        expect(action.actionable).to eq(notice)
      end
    end
  end
end
