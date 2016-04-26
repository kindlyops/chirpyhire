require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:organization) { create(:organization, :with_account, :with_question) }
  let(:account) { organization.accounts.first }

  let(:search) { create(:search, account: account) }
  let(:candidates) { create_list(:candidate, 2, organization: organization) }

  describe "#result" do
    context "with good fits" do
      before(:each) do
        search.candidates << candidates
        search.search_candidates.each(&:good_fit!)
      end

      it "is Found caregiver" do
        expect(search.result).to eq("Found caregiver")
      end
    end

    context "without good fits" do
      it "is In progress" do
        expect(search.result).to eq("In progress")
      end
    end
  end

  describe "#good_fits" do
    context "with good fits" do
      before(:each) do
        search.candidates << candidates
      end

      it "is the candidates of good fit search candidates" do
        first_search_candidate = search.search_candidates.first
        first_search_candidate.good_fit!

        expect(search.good_fits).to eq([first_search_candidate.candidate])
      end
    end

    context "without good fits" do
      it "is empty" do
        expect(search.good_fits).to be_empty
      end
    end
  end

  describe "#start" do
    context "with search candidates" do
      before(:each) do
        search.candidates << candidates
      end

      it "creates an inquisitor job for each search candidate" do
        expect(InquisitorJob).to receive(:perform_later).exactly(candidates.count).times
        search.start
      end
    end
  end

  describe "#first_search_question" do
    context "without search questions" do
      it "is nil" do
        expect(search.first_search_question).to be_nil
      end
    end

    context "with search questions" do
      let!(:first_question) { organization.questions.first }
      let!(:second_question) do
        question = create(:question)
        organization.questions << question
        question
      end
      let!(:first_search_question) { create(:search_question, search: search, question: first_question, next_question: second_question) }
      let!(:last_search_question) { create(:search_question, search: search, question: second_question) }

      it "returns the search question without a previous question" do
        expect(search.first_search_question).to eq(first_search_question)
      end
    end
  end

  describe "#search_question_after" do
    let!(:first_question) { organization.questions.first }
    let!(:second_question) do
      question = create(:question)
      organization.questions << question
      question
    end
    let!(:first_search_question) { create(:search_question, search: search, question: first_question, next_question: second_question) }
    let!(:last_search_question) { create(:search_question, search: search, question: second_question) }

    context "with a search question after the search question" do
      it "returns the next search question" do
        expect(search.search_question_after(first_search_question)).to eq(last_search_question)
      end
    end

    context "without another search question" do
      it "is nil" do
        expect(search.search_question_after(last_search_question)).to be_nil
      end
    end
  end
end
