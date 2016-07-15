require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:admin) { create(:user, :with_account, organization: organization) }

  before(:each) do
    sign_in(admin.account)
  end

  describe "#create" do
    let(:message_params) do
      {
        user_id: user.id,
        message: {
          body: Faker::Lorem.sentence
        }
      }
    end

    context "with a candidate" do
      context "subscribed" do
        let!(:candidate) { create(:candidate, subscribed: true, user: user) }

        it "provides a helpful message" do
          post :create, params: message_params
          expect(flash[:notice]).to eq("Message sent!")
        end

        it "creates a new message" do
          expect {
            post :create, params: message_params
          }.to change{user.messages.count}.by(1)
        end

        it "creates a new activity" do
          expect {
            post :create, params: message_params
          }.to change{user.activities.count}.by(1)
        end

        it "sends the message" do
          expect {
            post :create, params: message_params
          }.to change{FakeMessaging.messages.count}.by(1)
        end
      end

      context "unsubscribed" do
        let!(:candidate) { create(:candidate, subscribed: false, user: user) }

        it "provides a helpful alert message" do
          post :create, params: message_params
          expect(flash[:alert]).to eq("Unfortunately they are unsubscribed! You can't text unsubscribed candidates using Chirpyhire.")
        end

        it "does not create a new message" do
          expect {
            post :create, params: message_params
          }.not_to change{user.messages.count}
        end

        it "does not create a new activity" do
          expect {
            post :create, params: message_params
          }.not_to change{user.activities.count}
        end

        it "does not send the message" do
          expect {
            post :create, params: message_params
          }.not_to change{FakeMessaging.messages.count}
        end
      end
    end
  end
end
