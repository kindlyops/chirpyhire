require 'rails_helper'

RSpec.describe SmsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:phone_number) { organization.phone_number }

  describe "#unknown_chirp" do
    context "without authenticity token" do
      before(:each) do
        ActionController::Base.allow_forgery_protection = true
      end

      after(:each) do
        ActionController::Base.allow_forgery_protection = false
      end

      it "is OK" do
        post :unknown_chirp, params: { "MessageSid" => "123", "To" => phone_number }
        expect(response).to be_ok
      end

      it "does not create a chirp" do
        expect {
          post :unknown_chirp, params: { "MessageSid" => "123", "To" => phone_number }
        }.not_to change{Chirp.count}
      end

      it "creates an UnknownChirpHandlerJob" do
        expect {
          post :unknown_chirp, params: { "MessageSid" => "123", "To" => phone_number }
        }.to have_enqueued_job(UnknownChirpHandlerJob)
      end
    end

    it "sets the Content-Type to text/xml" do
      post :unknown_chirp, params: { "MessageSid" => "123", "To" => phone_number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a user" do
      expect {
        post :unknown_chirp, params: { "MessageSid" => "123", "To" => phone_number }
      }.to change{organization.users.count}.by(1)
    end
  end
end
