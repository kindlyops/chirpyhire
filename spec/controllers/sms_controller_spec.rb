require 'rails_helper'

RSpec.describe SmsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:phone_number) { organization.phone_number }

  describe "#text" do
    context "without authenticity token" do
      before(:each) do
        ActionController::Base.allow_forgery_protection = true
      end

      after(:each) do
        ActionController::Base.allow_forgery_protection = false
      end

      it "is OK" do
        post :unknown_chirp, { "MessageSid" => "123", "To" => phone_number }
        expect(response).to be_ok
      end
    end

    it "sets the Content-Type to text/xml" do
      post :unknown_chirp, { "MessageSid" => "123", "To" => phone_number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a user" do
      expect {
        post :unknown_chirp, { "MessageSid" => "123", "To" => phone_number }
      }.to change{organization.users.count}.by(1)
    end

    context "without an outstanding reply task" do
      it "creates an outstanding reply task for the user" do
        expect {
          post :unknown_chirp, { "MessageSid" => "123", "To" => phone_number }
        }.to change{organization.tasks.outstanding.count}.by(1)
      end
    end
  end
end
