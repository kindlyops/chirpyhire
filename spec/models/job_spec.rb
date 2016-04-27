require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:organization) { create(:organization, :with_account, :with_question) }
  let(:account) { organization.accounts.first }

  let(:job) { create(:job, account: account) }
  let(:candidates) { create_list(:candidate, 2, organization: organization) }

  describe "#result" do
    context "with good fits" do
      before(:each) do
        job.candidates << candidates
        job.job_candidates.each(&:good_fit!)
      end

      it "is Found caregiver" do
        expect(job.result).to eq("Found caregiver")
      end
    end

    context "without good fits" do
      it "is In progress" do
        expect(job.result).to eq("In progress")
      end
    end
  end

  describe "#good_fits" do
    context "with good fits" do
      before(:each) do
        job.candidates << candidates
      end

      it "is the candidates of good fit job candidates" do
        first_job_candidate = job.job_candidates.first
        first_job_candidate.good_fit!

        expect(job.good_fits).to eq([first_job_candidate.candidate])
      end
    end

    context "without good fits" do
      it "is empty" do
        expect(job.good_fits).to be_empty
      end
    end
  end

  describe "#start" do
    context "with job candidates" do
      before(:each) do
        job.candidates << candidates
      end

      it "creates an inquisitor job for each job candidate" do
        expect(InquisitorJob).to receive(:perform_later).exactly(candidates.count).times
        job.start
      end
    end
  end

  describe "#first_job_question" do
    context "without job questions" do
      it "is nil" do
        expect(job.first_job_question).to be_nil
      end
    end

    context "with job questions" do
      let!(:first_question) { organization.questions.first }
      let!(:second_question) do
        question = create(:question)
        organization.questions << question
        question
      end
      let!(:first_job_question) { create(:job_question, job: job, question: first_question, next_question: second_question) }
      let!(:last_job_question) { create(:job_question, job: job, question: second_question) }

      it "returns the job question without a previous question" do
        expect(job.first_job_question).to eq(first_job_question)
      end
    end
  end

  describe "#job_question_after" do
    let!(:first_question) { organization.questions.first }
    let!(:second_question) do
      question = create(:question)
      organization.questions << question
      question
    end
    let!(:first_job_question) { create(:job_question, job: job, question: first_question, next_question: second_question) }
    let!(:last_job_question) { create(:job_question, job: job, question: second_question) }

    context "with a job question after the job question" do
      it "returns the next job question" do
        expect(job.job_question_after(first_job_question)).to eq(last_job_question)
      end
    end

    context "without another job question" do
      it "is nil" do
        expect(job.job_question_after(last_job_question)).to be_nil
      end
    end
  end
end
