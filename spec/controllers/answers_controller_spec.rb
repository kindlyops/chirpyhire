require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:ideal_profile) { user.organization.ideal_profile }
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
      post :create, params
      expect(response).to be_ok
    end

    let(:ideal_feature) { create(:ideal_feature, ideal_profile: ideal_profile) }
    let(:candidate_feature) { create(:candidate_feature, ideal_feature: ideal_feature) }
    let(:inquiry) { create(:inquiry, user: user, candidate_feature: candidate_feature) }

    it "creates a AnswerHandlerJob" do
      expect {
        post :create, params
      }.to have_enqueued_job(AnswerHandlerJob).with(user, inquiry, inbound_message.sid)
    end
  end
end
