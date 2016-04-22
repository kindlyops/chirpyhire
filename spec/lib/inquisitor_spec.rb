require 'rails_helper'

RSpec.describe Inquisitor, vcr: { cassette_name: "Inquisitor" } do
  let(:organization) { create(:organization, :with_successful_phone, :with_account) }
  let(:account) { organization.accounts.first }
  let(:search) { create(:search, account: account) }
  let(:lead) { create(:lead, organization: organization) }
  let(:question) { create(:question, organization: organization) }

  before(:each) do
    search.leads << lead
    search.questions << question
  end

  let(:search_lead) { search.search_leads.first }
  let(:search_question) { search.search_questions.first }

  subject { Inquisitor.new(search_lead: search_lead, search_question: search_question) }

  describe "#call" do
    it "ensures the search lead is processing" do
      subject.call
      expect(search_lead.processing?).to eq(true)
    end

    it "creates a message" do
      expect {
        subject.call
      }.to change{organization.messages.count}.by(1)
    end

    it "creates an inquiry for the lead and question" do
      expect {
        expect {
          subject.call
        }.to change{question.inquiries.count}.by(1)
      }.to change{lead.inquiries.count}.by(1)
    end

    context "with an existing search in progress" do
      let(:existing_search) { create(:search, account: account) }
      before(:each) do
        existing_search.leads << lead
        existing_search.search_leads.each(&:processing!)
      end

      context "and the search lead is some how processing" do
        before(:each) do
          search_lead.processing!
        end

        it "ensures the search lead is pending" do
          subject.call
          expect(search_lead.pending?).to eq(true)
        end

        it "does not create a message" do
          expect {
            subject.call
          }.not_to change{organization.messages.count}
        end

        it "does not create an inquiry for the lead and question" do
          expect {
            expect {
              subject.call
            }.not_to change{question.inquiries.count}
          }.not_to change{lead.inquiries.count}
        end
      end
    end

    context "if the search question isn't present" do
      let(:search_question) { nil }

      it "marks the search lead as finished" do
        subject.call
        expect(search_lead.finished?).to eq(true)
      end

      context "with all positive answers in the search" do
        before(:each) do
          second_question = create(:question, organization: organization)
          search.questions << second_question
          create(:answer, lead: lead, question: question, body: "Y")
          create(:answer, lead: lead, question: second_question, body: "Y")
        end

        it "marks the search lead as a good fit" do
          subject.call
          expect(search_lead.good_fit?).to eq(true)
        end
      end

      context "with a negative answer" do
        before(:each) do
          create(:answer, lead: lead, question: question, body: "N")
        end

        it "marks the search lead as a bad fit" do
          subject.call
          expect(search_lead.bad_fit?).to eq(true)
        end
      end

      context "with other pending searches for the lead" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_lead) { pending_search.search_leads.find_by(lead: lead) }

        before(:each) do
          pending_search.leads << lead
        end

        it "starts the pending search with the next search lead" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_lead, pending_search.first_search_question)
          subject.call
        end
      end
    end

    context "if the lead recently answered the question negatively" do
      let!(:answer) { create(:answer, body: "N", question: question, lead: lead) }

      it "marks the search lead as a bad fit" do
        subject.call
        expect(search_lead.bad_fit?).to eq(true)
      end

      it "marks the search lead as finished" do
        subject.call
        expect(search_lead.finished?).to eq(true)
      end

      context "with other pending searches for the lead" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_lead) { pending_search.search_leads.find_by(lead: lead) }

        before(:each) do
          pending_search.leads << lead
        end

        it "starts the pending search with the next search lead" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_lead, pending_search.first_search_question)
          subject.call
        end
      end
    end

    context "if the lead recently answered another question in the search negatively" do
      let(:another_question) { create(:question, organization: organization) }
      let!(:answer) { create(:answer, body: "N", question: another_question, lead: lead) }

      before(:each) do
        search.questions << another_question
      end

      it "marks the search lead as a bad fit" do
        subject.call
        expect(search_lead.bad_fit?).to eq(true)
      end

      it "marks the search lead as finished" do
        subject.call
        expect(search_lead.finished?).to eq(true)
      end

      context "with other pending searches for the lead" do
        let(:pending_search) { create(:search, :with_search_question, account: account) }
        let(:next_search_lead) { pending_search.search_leads.find_by(lead: lead) }
        let(:first_search_question) { pending_search.search_questions.find_by(previous_question: nil) }

        before(:each) do
          pending_search.leads << lead
        end

        it "starts the pending search with the next search lead" do
          expect(InquisitorJob).to receive(:perform_later).with(next_search_lead, first_search_question)
          subject.call
        end
      end
    end

    context "if the lead recently answered the question positively" do
      let!(:answer) { create(:answer, body: "Y", question: question, lead: lead) }

      context "with a next question" do
        let(:next_question) { create(:question, organization: organization) }
        let(:next_search_question) { search.search_questions.create(question: next_question) }

        before(:each) do
          search_question.update(next_question: next_question)
        end

        it "asks the next question" do
          expect(InquisitorJob).to receive(:perform_later).with(search_lead, next_search_question)
          subject.call
        end
      end
    end
  end
end
