require 'rails_helper'

RSpec.describe SmsController, type: :controller do
  let(:phone) { create(:phone) }

  describe "#text" do
    context "without authenticity token" do
      before(:each) do
        ActionController::Base.allow_forgery_protection = true
      end

      after(:each) do
        ActionController::Base.allow_forgery_protection = false
      end

      it "is OK" do
        post :text, { "MessageSid" => "123", "To" => phone.number }
        expect(response).to be_ok
      end
    end

    it "sets the Content-Type to text/xml" do
      post :text, { "MessageSid" => "123", "To" => phone.number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a message" do
      expect {
        post :text, { "MessageSid" => "123", "To" => phone.number }
      }.to change{Message.count}.by(1)
    end

    it "returns a friendly error message" do
      post :text, { "MessageSid" => "123", "To" => phone.number }
      expect(response.body).to include("Sorry I didn't understand that.")
    end
  end
end
