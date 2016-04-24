require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:organization) { create(:organization, :with_owner) }
  let(:question) { create(:question, industry: organization.industry) }
  describe "#body_for" do
    let(:lead) { create(:lead, organization: organization) }
    context "with prelude flag" do
      it "includes the prelude" do
        expect(question.body_for(lead, prelude: true)).to include("We have a new client \
and want to see if you might be a good fit.")
      end
    end

    context "without prelude flag" do
      it "does not include the prelude" do
        expect(question.body_for(lead)).not_to include("We have a new client \
and want to see if you might be a good fit.")
      end
    end

    it "includes the question body" do
      expect(question.body_for(lead)).to include(question.body)
    end

    it "includes the preamble" do
      expect(question.body_for(lead)).to include("Reply Y or N.")
    end
  end

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
