require 'rails_helper'

RSpec.describe AnswerHandler do
  include RSpec::Rails::Matchers

  let!(:user) { create(:user) }
  let!(:inquiry) { create(:inquiry, user: user) }
  let!(:inbound_message) { FakeMessaging.inbound_message(user, user.organization) }

  describe ".call" do
    context "with an answer format that matches the feature format" do
      it "creates a message" do
        expect {
          AnswerHandler.call(user, inquiry, inbound_message.sid)
        }.to change{user.messages.count}.by(1)
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
    end

    context "with an answer format that doesn't matches the feature format" do
      context "image mismatch", vcr: { cassette_name: "AnswerHandlerFormatMismatch" } do
        let(:body) { "a test body" }
        let!(:inbound_message) { FakeMessaging.inbound_message(user, user.organization, body, format: :text) }

        it "creates a message" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.to change{user.messages.count}.by(1)
        end

        it "creates a task" do
          expect {
            AnswerHandler.call(user, inquiry, inbound_message.sid)
          }.to change{Task.count}.by(1)
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
