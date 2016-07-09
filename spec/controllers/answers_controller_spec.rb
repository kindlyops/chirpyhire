require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:message) { create(:message, user: user) }
  let(:candidate_persona) { user.organization.candidate_persona }
  let(:inbound_message) { FakeMessaging.inbound_message(user, user.organization) }

  describe "#create" do
    let(:params) do
      {
        "To" => inbound_message.to,
        "From" => inbound_message.from,
        "Body" => inbound_message.body,
        "MessageSid" => inbound_message.sid,
        "MediaUrl0" => inbound_message.media_urls[0]
      }
    end

    it "is ok" do
      post :create, params: params
      expect(response).to be_ok
    end

    let(:persona_feature) { create(:persona_feature, candidate_persona: candidate_persona) }
    let(:candidate_feature) { create(:candidate_feature, persona_feature: persona_feature) }

    context "with an outstanding inquiry" do
      let(:inquiry) { create(:inquiry, message: message, candidate_feature: candidate_feature) }

      it "creates a AnswerHandlerJob" do
        expect {
          post :create, params: params
        }.to have_enqueued_job(AnswerHandlerJob).with(user, inquiry, inbound_message.sid)
      end
    end

    context "without an outstanding inquiry" do
      let(:inquiry) { nil }

      it "does not create an AnswerHandlerJob" do
        expect {
          post :create, params: params
        }.not_to have_enqueued_job(AnswerHandlerJob)
      end

      it "creates an UnknownMessageHandlerJob" do
        expect {
          post :create, params: params
        }.to have_enqueued_job(UnknownMessageHandlerJob).with(user, inbound_message.sid)
      end
    end
  end
end
