require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:organization) { create(:organization, :with_phone, :with_account) }
  let(:account) { organization.accounts.first }
  let(:sender_phone_number) { "+15555555555" }
  let(:params) do
    {
      "To" => organization.phone_number,
      "From" => sender_phone_number,
      "MessageSid" => "123",
      "Body" => "Y"
    }
  end

  describe "#create" do
    context "without an ongoing job search for the candidate" do
      it "returns an error" do
        post :create, params
        expect(response.body).to include("Sorry I didn't understand that.")
      end

      it "does not create an answer" do
        expect {
          post :create, params
        }.not_to change{Answer.count}
      end

      it "creates a message" do
        expect {
          post :create, params
        }.to change{organization.messages.count}.by(1)
      end
    end

    context "with an ongoing job search for the candidate" do
      let(:job) { create(:job, account: account) }
      let(:questions) do
        questions = create_list(:question, 2)
        organization.questions << questions
      end
      let(:user) { create(:user, phone_number: sender_phone_number) }
      let(:candidate) { create(:candidate, organization: organization, user: user) }

      let!(:first_job_question) do
        job_question = create(:job_question, question: questions.first, next_question: questions.last)
        job.job_questions << job_question
        job_question
      end

      let!(:second_job_question) do
        job_question = create(:job_question, question: questions.last)
        job.job_questions << job_question
        job_question
      end

      let!(:job_candidate) do
        job.candidates << candidate
        candidate.job_candidates.each(&:processing!)
        candidate.job_candidates.find_by(job: job)
      end

      context "without an inquiry" do
        it "returns an error" do
          post :create, params
          expect(response.body).to include("Sorry I didn't understand that.")
        end

        it "does not create an answer" do
          expect {
            post :create, params
          }.not_to change{Answer.count}
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{organization.messages.count}.by(1)
        end
      end

      context "with an inquiry" do
        let!(:inquiry) { create(:inquiry, candidate: candidate, question: questions.first) }

        it "creates an answer" do
          expect {
            expect {
              post :create, params
            }.to change{candidate.answers.count}.by(1)
          }.to change{inquiry.question.answers.count}.by(1)
        end

        it "is OK" do
          post :create, params
          expect(response).to be_ok
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{organization.messages.count}.by(1)
        end

        it "continues the search" do
          expect(InquisitorJob).to receive(:perform_later).with(job_candidate, second_job_question)
          post :create, params
        end
      end
    end
  end
end
