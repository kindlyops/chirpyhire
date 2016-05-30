require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:candidate) { create(:candidate, :with_inquiry) }
  let(:user) { candidate.user }
  let(:answer) { FakeMessaging.inbound_message(user, candidate.organization) }
  let!(:profile) { create(:profile, :with_features, organization: user.organization) }

  describe "#create" do
    let(:params) do
      {
        "To" => answer.to,
        "From" => answer.from,
        "Body" => answer.body,
        "MessageSid" => answer.sid,
        "MediaUrl0" => answer.media_urls[0]
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

      it "creates a ProfileJob" do
        expect {
          post :create, params
        }.to have_enqueued_job(ProfileJob).with(user, profile)
      end
    end

    context "with an answer format that doesn't matches the response format" do
      context "image mismatch" do
        let(:candidate) { create(:candidate, :with_inquiry) }
        let(:answer) { FakeMessaging.inbound_message(candidate.user, candidate.organization, format: :text) }

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
