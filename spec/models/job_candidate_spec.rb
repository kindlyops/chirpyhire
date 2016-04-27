require 'rails_helper'

RSpec.describe JobCandidate, type: :model do
  let(:job_candidate) { create(:job_candidate) }
  let(:candidate) { job_candidate.candidate }
  let(:job) { job_candidate.job }
  let(:job_question) { create(:job_question, job: job) }
  let(:question) { job_question.question }

  describe "#determine_fit" do
    context "with recent answers to job questions" do
      before(:each) do
        create(:answer, candidate: candidate, question: question)
      end

      context "that are negative" do
        before(:each) do
          Answer.update_all(body: "N")
        end

        it "is a bad fit" do
          expect {
            job_candidate.determine_fit
          }.to change{job_candidate.fit}.from("possible_fit").to("bad_fit")
        end
      end

      context "that are positive" do
        context "that are all answered" do
          before(:each) do
            second_job_question = create(:job_question, job: job)
            create(:answer, candidate: candidate, question: second_job_question.question)
            Answer.update_all(body: "Y")
          end

          it "is a good fit" do
            expect {
              job_candidate.determine_fit
            }.to change{job_candidate.fit}.from("possible_fit").to("good_fit")
          end
        end

        context "that are not all answered" do
          before(:each) do
            second_job_question = create(:job_question, job: job)
            Answer.update_all(body: "Y")
          end

          it "is a possible fit" do
            job_candidate.determine_fit
            expect(job_candidate.possible_fit?).to eq(true)
          end
        end
      end
    end
  end
end
