require 'rails_helper'

RSpec.describe Inquisitor, vcr: { cassette_name: "Inquisitor" } do

  let(:organization) { create(:organization, :with_successful_phone, :with_owner, :with_question) }
  let(:account) { organization.accounts.first }
  let(:search) { create(:search, account: account) }
  let(:candidate) { create(:candidate, organization: organization) }
  let(:question) do
    question = create(:question)
    organization.questions << question
    question
  end

  before(:each) do
    search.candidates << candidate
    search.questions << question
  end

  let(:search_candidate) { search.search_candidates.first }
  let(:search_question) { search.search_questions.first }

  subject { Inquisitor.new(search_candidate, search_question) }

  describe "#call" do
    it "ensures the search candidate is processing" do
      subject.call
      expect(search_candidate.processing?).to eq(true)
    end

    it "creates a message" do
      expect {
        subject.call
      }.to change{organization.messages.count}.by(1)
    end

    it "creates an inquiry for the candidate and question" do
      expect {
        expect {
          subject.call
        }.to change{question.inquiries.count}.by(1)
      }.to change{candidate.inquiries.count}.by(1)
    end

    context "with an existing search in progress" do
      let(:existing_search) { create(:search, account: account) }
      before(:each) do
        existing_search.candidates << candidate
        existing_search.search_candidates.each(&:processing!)
      end

      context "and the search candidate is some how processing" do
        before(:each) do
          search_candidate.processing!
        end

        it "ensures the search candidate is pending" do
          subject.call
          expect(search_candidate.pending?).to eq(true)
        end

        it "does not create a message" do
          expect {
            subject.call
          }.not_to change{organization.messages.count}
        end

        it "does not create an inquiry for the candidate and question" do
          expect {
            expect {
              subject.call
            }.not_to change{question.inquiries.count}
          }.not_to change{candidate.inquiries.count}
        end
      end
    end

    context "if the search question isn't present" do
      let(:search_question) { nil }

      it "marks the search candidate as finished" do
        subject.call
        expect(search_candidate.finished?).to eq(true)
      end

      context "with all positive answers in the search" do
        before(:each) do
          second_question = create(:question)
          organization.questions << second_question
          search.questions << second_question
          create(:answer, candidate: candidate, question: question, body: "Y")
          create(:answer, candidate: candidate, question: second_question, body: "Y")
        end

        it "marks the search candidate as a good fit" do
          subject.call
          expect(search_candidate.good_fit?).to eq(true)
        end
      end

      context "with a negative answer" do
        before(:each) do
          create(:answer, candidate: candidate, question: question, body: "N")
        end

        it "marks the search candidate as a bad fit" do
          subject.call
          expect(search_candidate.bad_fit?).to eq(true)
        end
      end

      context "with other pending searches for the candidate" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_candidate) { pending_search.search_candidates.find_by(candidate: candidate) }

        before(:each) do
          pending_search.candidates << candidate
        end

        it "starts the pending search with the next search candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_candidate, pending_search.first_search_question)
          subject.call
        end
      end
    end

    context "if the candidate recently answered the question negatively" do
      let!(:answer) { create(:answer, body: "N", question: question, candidate: candidate) }

      it "marks the search candidate as a bad fit" do
        subject.call
        expect(search_candidate.bad_fit?).to eq(true)
      end

      it "marks the search candidate as finished" do
        subject.call
        expect(search_candidate.finished?).to eq(true)
      end

      context "with other pending searches for the candidate" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_candidate) { pending_search.search_candidates.find_by(candidate: candidate) }

        before(:each) do
          pending_search.candidates << candidate
        end

        it "starts the pending search with the next search candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_candidate, pending_search.first_search_question)
          subject.call
        end
      end
    end

    context "if the candidate recently answered another question in the search negatively" do
      let(:another_question) do
        question = create(:question)
        organization.questions << question
        question
      end
      let!(:answer) { create(:answer, body: "N", question: another_question, candidate: candidate) }

      before(:each) do
        search.questions << another_question
      end

      it "marks the search candidate as a bad fit" do
        subject.call
        expect(search_candidate.bad_fit?).to eq(true)
      end

      it "marks the search candidate as finished" do
        subject.call
        expect(search_candidate.finished?).to eq(true)
      end

      context "with other pending searches for the candidate" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_candidate) { pending_search.search_candidates.find_by(candidate: candidate) }
        let(:first_search_question) { pending_search.search_questions.find_by(previous_question: nil) }

        before(:each) do
          pending_search.candidates << candidate
        end

        it "starts the pending search with the next search candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_candidate, first_search_question)
          subject.call
        end
      end
    end

    context "if the candidate recently answered the question positively" do
      let!(:answer) { create(:answer, body: "Y", question: question, candidate: candidate) }

      context "with a next question" do
        let(:next_question) do
          question = create(:question)
          organization.questions << question
          question
        end
        let(:next_search_question) { search.search_questions.create(question: next_question) }

        before(:each) do
          search_question.update(next_question: next_question)
        end

        it "asks the next question" do
          expect(InquisitorJob).to receive(:perform_later).with(search_candidate, next_search_question)
          subject.call
        end
      end
    end
  end
end
