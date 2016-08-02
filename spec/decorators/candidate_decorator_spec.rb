require 'rails_helper'

RSpec.describe CandidateDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateDecorator.new(model) }

  describe "#choices" do
    context "with choices" do
      let(:question) { create(:question, :choice, survey: model.organization.create_survey) }
      let(:option) { "Live-in" }
      let(:choice_properties) do
        {
          choice_option: option,
          child_class: "choice"
        }
      end

      before(:each) do
        create(:candidate_feature, candidate: model, properties: choice_properties, category: question.category)
      end

      it "is an array of choices" do
        expect(candidate.choices.first.option).to eq(option)
        expect(candidate.choices.first.category).to eq(question.category.name)
      end
    end

    context "without choices" do
      it "is an empty array" do
        expect(candidate.choices).to eq([])
      end
    end
  end

  describe "#documents" do
    context "with documents" do
      let(:question) { create(:question, survey: model.organization.create_survey) }
      let(:url0) { "http://www.freedigitalphotos.net/images/img/homepage/87357.jpg" }
      let(:document_properties) do
        {
          url0: url0,
          child_class: "document"
        }
      end

      before(:each) do
        create(:candidate_feature, candidate: model, properties: document_properties, category: question.category)
      end

      it "is an array of documents" do
        expect(candidate.documents.first.first_page).to eq(url0)
        expect(candidate.documents.first.category).to eq(question.category.name)
      end
    end

    context "without documents" do
      it "is an empty array" do
        expect(candidate.documents).to eq([])
      end
    end
  end
end
