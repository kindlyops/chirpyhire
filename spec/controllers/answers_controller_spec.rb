require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:candidate) { create(:candidate, :with_inquiry) }
  let(:user) { candidate.user }
  let(:answer) { FakeMessaging.inbound_message(user, candidate.organization) }

  describe "#create" do
    let(:params) do
      {
        "To" => answer.to,
        "From" => answer.from,
        "Body" => answer.body,
        "MessageSid" => answer.sid
      }
    end

    it "is ok" do
      post :create, params
      expect(response).to be_ok
    end

    context "with an answer format that matches the response format" do
      let(:trigger) { candidate.outstanding_inquiry.trigger }

      it "creates a message" do
        expect {
          post :create, params
        }.to change{user.messages.count}.by(1)
      end

      it "creates an answer" do
        expect {
          post :create, params
        }.to change{Answer.count}.by(1)
      end

      it "creates an answer automaton job" do
        expect {
          post :create, params
        }.to have_enqueued_job(AutomatonJob).with(user, trigger)
      end
    end

    context "with an answer format that doesn't matches the response format" do
      context "text mismatch" do
        let(:answer) { FakeMessaging.inbound_message(user, candidate.organization, format: :image) }

        let(:params) do
          {
            "To" => answer.to,
            "From" => answer.from,
            "Body" => answer.body,
            "MessageSid" => answer.sid,
            "MediaUrl0" => answer.media_urls[0]
          }
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{user.messages.count}.by(1)
        end

        it "creates a task" do
          expect {
            post :create, params
          }.to change{Task.count}.by(1)
        end

        it "does not create an answer" do
          expect {
            post :create, params
          }.not_to change{Answer.count}
        end
      end

      context "image mismatch" do
        let(:candidate) { create(:candidate, :with_inquiry, inquiry_format: :image) }
        let(:answer) { FakeMessaging.inbound_message(candidate.user, candidate.organization) }

        let(:params) do
          {
            "To" => answer.to,
            "From" => answer.from,
            "Body" => answer.body,
            "MessageSid" => answer.sid
          }
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{user.messages.count}.by(1)
        end

        it "creates a task" do
          expect {
            post :create, params
          }.to change{Task.count}.by(1)
        end

        it "does not create an answer" do
          expect {
            post :create, params
          }.not_to change{Answer.count}
        end
      end
    end
  end
end
