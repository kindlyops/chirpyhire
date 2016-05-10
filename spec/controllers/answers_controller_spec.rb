require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:organization) { create(:organization, :with_phone) }
  let(:user) { create(:user, organization: organization) }
  let(:candidate) { create(:candidate, user: user) }
  let(:message) { create(:message, messageable: candidate) }
  let!(:inquiry) { create(:inquiry, message: message) }

  describe "#create" do
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => candidate.phone_number,
        "Body" => Faker::Lorem.word,
        "MessageSid" => Faker::Lorem.word
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
        }.to have_enqueued_job(AutomatonJob).with(candidate, inquiry.question, "answer")
      end
    end

    context "with an answer format that doesn't matches the response format" do
      let(:params) do
        {
          "To" => organization.phone_number,
          "From" => candidate.phone_number,
          "Body" => nil,
          "MessageSid" => Faker::Lorem.word,
          "MediaUrl0" => "/example/path/to/image.png"
        }
      end

      it "does not create an answer" do
        expect {
          post :create, params
        }.not_to change{Answer.count}
      end

      it "creates an invalid answer automaton job" do
        expect {
          post :create, params
        }.to have_enqueued_job(AutomatonJob).with(candidate, inquiry.question, "invalid_answer")
      end
    end
  end
end
