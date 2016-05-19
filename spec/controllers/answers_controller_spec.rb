require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:organization) { create(:organization, :with_phone) }
  let(:user) { create(:user, organization: organization) }
  let(:candidate) { create(:candidate, user: user) }
  let!(:inquiry) { create(:inquiry, user: user) }

  let(:messaging) { FakeMessaging.new("foo", "bar") }
  let(:from) { candidate.phone_number }
  let(:to) { organization.phone_number }
  let(:body) { Faker::Lorem.word }
  let(:message) { messaging.create(from: from, to: to, body: body) }
  let!(:trigger) { create(:trigger, :answer, organization: organization, observable: inquiry.question) }

  describe "#create" do
    let(:params) do
      {
        "To" => to,
        "From" => from,
        "Body" => Faker::Lorem.word,
        "MessageSid" => message.sid
      }
    end

    it "is ok" do
      post :create, params
      expect(response).to be_ok
    end

    context "with an answer format that matches the response format" do
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
        let(:message) { messaging.create(from: from, to: to, body: "", format: :image) }

        let(:params) do
          {
            "To" => to,
            "From" => from,
            "Body" => "",
            "MessageSid" => message.sid,
            "MediaUrl0" => "/example/path/to/image.png"
          }
        end

        it "lets the user know the format was wrong" do
          post :create, params
          expect(response.body).to include("We were looking for a text answer but you sent an image. Please answer with a text.")
        end

        it "does not create an answer" do
          expect {
            post :create, params
          }.not_to change{Answer.count}
        end
      end

      context "image mismatch" do
        let!(:inquiry) { create(:inquiry, :with_image_question, user: user) }
        let(:message) { messaging.create(from: from, to: to, body: "foo", format: :text) }

        let(:params) do
          {
            "To" => to,
            "From" => from,
            "Body" => "foo",
            "MessageSid" => message.sid
          }
        end

        it "lets the user know the format was wrong" do
          post :create, params
          expect(response.body).to include("We were looking for an image answer but you sent a text. Please answer with an image.")
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
