require 'rails_helper'

RSpec.describe Inquisitor, vcr: { cassette_name: "Inquisitor" } do

  let(:organization) { create(:organization, :with_successful_phone, :with_owner, :with_question) }
  let(:account) { organization.accounts.first }
  let(:job) { create(:job, account: account) }
  let(:candidate) { create(:candidate, organization: organization) }
  let(:question) do
    question = create(:question)
    organization.questions << question
    question
  end

  before(:each) do
    job.candidates << candidate
    job.questions << question
  end

  let(:job_candidate) { job.job_candidates.first }
  let(:job_question) { job.job_questions.first }

  subject { Inquisitor.new(job_candidate, job_question) }

  describe "#call" do
    it "ensures the job candidate is processing" do
      subject.call
      expect(job_candidate.processing?).to eq(true)
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

    context "with an existing job search in progress" do
      let(:existing_job) { create(:job, account: account) }
      before(:each) do
        existing_job.candidates << candidate
        existing_job.job_candidates.each(&:processing!)
      end

      context "and the job candidate is some how processing" do
        before(:each) do
          job_candidate.processing!
        end

        it "ensures the job candidate is pending" do
          subject.call
          expect(job_candidate.pending?).to eq(true)
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

    context "if the job question isn't present" do
      let(:job_question) { nil }

      it "marks the job candidate as finished" do
        subject.call
        expect(job_candidate.finished?).to eq(true)
      end

      context "with all positive answers in the search" do
        before(:each) do
          second_question = create(:question)
          organization.questions << second_question
          job.questions << second_question
          create(:answer, candidate: candidate, question: question, body: "Y")
          create(:answer, candidate: candidate, question: second_question, body: "Y")
        end

        it "marks the job candidate as a good fit" do
          subject.call
          expect(job_candidate.good_fit?).to eq(true)
        end
      end

      context "with a negative answer" do
        before(:each) do
          create(:answer, candidate: candidate, question: question, body: "N")
        end

        it "marks the job candidate as a bad fit" do
          subject.call
          expect(job_candidate.bad_fit?).to eq(true)
        end
      end

      context "with other pending jobs for the candidate" do
        let(:pending_job) { create(:job, :with_job_question, account: account) }
        let(:next_job_candidate) { pending_job.job_candidates.find_by(candidate: candidate) }

        before(:each) do
          pending_job.candidates << candidate
        end

        it "starts the pending job search with the next job candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_job_candidate, pending_job.first_job_question)
          subject.call
        end
      end
    end

    context "if the candidate recently answered the question negatively" do
      let!(:answer) { create(:answer, body: "N", question: question, candidate: candidate) }

      it "marks the job candidate as a bad fit" do
        subject.call
        expect(job_candidate.bad_fit?).to eq(true)
      end

      it "marks the job candidate as finished" do
        subject.call
        expect(job_candidate.finished?).to eq(true)
      end

      context "with other pending jobs for the candidate" do
        let(:pending_job) { create(:job, :with_job_question, account: account) }
        let(:next_job_candidate) { pending_job.job_candidates.find_by(candidate: candidate) }

        before(:each) do
          pending_job.candidates << candidate
        end

        it "starts the pending job search with the next job candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_job_candidate, pending_job.first_job_question)
          subject.call
        end
      end
    end

    context "if the candidate recently answered another question in the job search negatively" do
      let(:another_question) do
        question = create(:question)
        organization.questions << question
        question
      end
      let!(:answer) { create(:answer, body: "N", question: another_question, candidate: candidate) }

      before(:each) do
        job.questions << another_question
      end

      it "marks the job candidate as a bad fit" do
        subject.call
        expect(job_candidate.bad_fit?).to eq(true)
      end

      it "marks the job candidate as finished" do
        subject.call
        expect(job_candidate.finished?).to eq(true)
      end

      context "with other pending jobs for the candidate" do
        let(:pending_job) { create(:job, :with_job_question, account: account) }
        let(:next_job_candidate) { pending_job.job_candidates.find_by(candidate: candidate) }
        let(:first_job_question) { pending_job.job_questions.find_by(previous_question: nil) }

        before(:each) do
          pending_job.candidates << candidate
        end

        it "starts the pending job search with the next job candidate" do
          expect(InquisitorJob).to receive(:perform_later).with(next_job_candidate, first_job_question)
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
        let(:next_job_question) { job.job_questions.create(question: next_question) }

        before(:each) do
          job_question.update(next_question: next_question)
        end

        it "asks the next question" do
          expect(InquisitorJob).to receive(:perform_later).with(job_candidate, next_job_question)
          subject.call
        end
      end
    end
  end
end
