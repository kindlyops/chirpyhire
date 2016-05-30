require 'rails_helper'

RSpec.describe SmsController, type: :controller do
  let(:organization) { create(:organization) }
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
        post :unknown_message, { "MessageSid" => "123", "To" => phone.number }
        expect(response).to be_ok
      end
    end

    it "sets the Content-Type to text/xml" do
      post :unknown_message, { "MessageSid" => "123", "To" => phone.number }
      expect(response.headers["Content-Type"]).to eq("text/xml")
    end

    it "creates a user" do
      expect {
        post :unknown_message, { "MessageSid" => "123", "To" => phone.number }
      }.to change{organization.users.count}.by(1)
    end

    context "without an outstanding reply task" do
      it "creates an outstanding reply task for the user" do
        expect {
          post :unknown_message, { "MessageSid" => "123", "To" => phone.number }
        }.to change{organization.tasks.outstanding.count}.by(1)
      end
    end

    context "with a preexisting outstanding reply task" do
      let(:user) { create(:user, organization: organization) }

      before(:each) do
        user.tasks.create(category: "reply")
      end

      it "does not create a new reply task" do
        expect {
          post :unknown_message, { "MessageSid" => "123", "From" => user.phone_number, "To" => phone.number }
        }.not_to change{organization.tasks.outstanding.count}
      end
    end
  end
end
