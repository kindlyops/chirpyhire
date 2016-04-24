require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:organization) { create(:organization, :with_owner) }
  let(:question) { create(:question, industry: organization.industry) }

  describe "#readonly?" do
    context "new record?" do
      it "is true" do
        expect(build(:question).readonly?).to eq(false)
      end
    end

    context "custom" do
      it "is false" do
        expect(question.readonly?).to eq(false)
      end
    end

    context "not custom" do
      let(:question) { create(:question, custom: false) }

      it "is true" do
        expect(question.readonly?).to eq(true)
      end
    end
  end
end
