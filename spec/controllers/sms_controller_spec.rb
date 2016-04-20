require 'rails_helper'

RSpec.describe SmsController, type: :controller do
  let(:organization) { create(:organization, :with_phone) }
  let(:phone) { organization.phone }

  describe "#text" do
    context "without authenticity token" do
      before(:each) do
        ActionController::Base.allow_forgery_protection = true
      end

      after(:each) do
        ActionController::Base.allow_forgery_protection = false
      end

      it "is OK" do
        post :error_message, { "MessageSid" => "123", "To" => phone.number }
        expect(response).to be_ok
      end
    end

    it "sets the Content-Type to text/xml" do
      post :error_message, { "MessageSid" => "123", "To" => phone.number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a message" do
      expect {
        post :error_message, { "MessageSid" => "123", "To" => phone.number }
      }.to change{organization.messages.count}.by(1)
    end

    it "returns a friendly error message" do
      post :error_message, { "MessageSid" => "123", "To" => phone.number }
      expect(response.body).to include("Sorry I didn't understand that.")
    end
  end
end
