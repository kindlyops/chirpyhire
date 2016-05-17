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
        post :invalid_message, { "MessageSid" => "123", "To" => phone.number }
        expect(response).to be_ok
      end
    end

    it "sets the Content-Type to text/xml" do
      post :invalid_message, { "MessageSid" => "123", "To" => phone.number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a user" do
      expect {
        post :invalid_message, { "MessageSid" => "123", "To" => phone.number }
      }.to change{organization.users.count}.by(1)
    end
  end
end
