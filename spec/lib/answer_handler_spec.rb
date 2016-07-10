require 'rails_helper'

RSpec.describe AnswerHandler do
  include RSpec::Rails::Matchers

  let(:candidate) { create(:candidate) }
  let!(:user) { candidate.user }
  let!(:message) { create(:message, user: user) }
  let(:persona_feature) { create(:persona_feature, candidate_persona: candidate.candidate_persona) }
  let(:candidate_feature) { create(:candidate_feature, persona_feature: persona_feature, candidate: candidate) }
  let!(:inquiry) { create(:inquiry, message: message, candidate_feature: candidate_feature) }
  let!(:inbound_message) { FakeMessaging.inbound_message(user, user.organization) }

  describe ".call" do
    context "with an answer format that matches the feature format" do
      it "creates a message" do
        expect {
          AnswerHandler.call(user, inquiry, inbound_message.sid)
        }.to change{Message.count}.by(1)
      end

      it "creates an answer" do
        expect {
          AnswerHandler.call(user, inquiry, inbound_message.sid)
        }.to change{Answer.count}.by(1)
      end

      it "creates a AutomatonJob" do
        expect {
          AnswerHandler.call(user, inquiry, inbound_message.sid)
        }.to have_enqueued_job(AutomatonJob).with(user, "answer")
      end

      context "when the inquiry has already been answered" do
        let!(:inquiry) { create(:inquiry, :with_answer, message: message, candidate_feature: candidate_feature) }

        it "does not create an answer" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.not_to change{Answer.count}
        end

        it "does not create an AutomatonJob" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.not_to have_enqueued_job(AutomatonJob)
        end

        it "creates a message" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.to change{Message.count}.by(1)
        end
      end
    end

    context "with an answer format that doesn't matches the feature format" do
      context "image mismatch", vcr: { cassette_name: "AnswerHandlerFormatMismatch" } do
        let(:body) { "a test body" }
        let!(:inbound_message) { FakeMessaging.inbound_message(user, user.organization, body, format: :text) }

        it "creates a message" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.to change{Message.count}.by(1)
        end

        it "creates an outstanding activity for the user" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.to change{user.outstanding_activities.count}.by(1)
        end

        it "does not create an answer" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.not_to change{Answer.count}
        end
      end
    end
  end
end
