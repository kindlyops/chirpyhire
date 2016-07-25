require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:admin) { create(:user, :with_account, organization: organization) }

  before(:each) do
    sign_in(admin.account)
  end

  let(:params) do
    { user_id: admin.id }
  end

  describe "#index" do
    it "is OK" do
      get :index, params: params
      expect(response).to be_ok
    end

    context "when user has unread messages" do
      let(:user) { create(:user, organization: organization, has_unread_messages: true) }
      it "marks the user as not having unread messages" do
        expect {
          get :index, params: { user_id: user.id }
        }.to change{user.reload.has_unread_messages?}.from(true).to(false)
      end
    end

    context "with messages" do
      it "returns the user's messages" do
        messages = create_list(:message, 3, user: admin)

        get :index, params: params
        expect(assigns(:messages)).to match_array(messages)
      end

      context "order" do
        let!(:old_message) { create(:message, id: 10, user: admin) }
        let!(:recent_message) { create(:message, id: 11, user: admin) }

        it "sorts by ID desc" do
          get :index, params: params
          expect(assigns(:messages)).to eq([recent_message, old_message])
        end
      end

      context "with other users on the same organization" do
        let(:user) { create(:user, organization: organization) }
        let!(:other_messages) { create_list(:message, 2, user: user) }

        it "does not return the other user's messages" do
          get :index, params: params
          expect(assigns(:messages)).not_to include(other_messages)
        end
      end

      context "with other organizations" do
        let!(:other_messages) { create_list(:message, 2) }
        it "does not return the other organization's messages" do
          get :index, params: params
          expect(assigns(:messages)).not_to include(other_messages)
        end
      end
    end
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

    context "with a user" do
      context "subscribed" do
        let(:user) { create(:user, subscribed: true, organization: organization) }

        it "provides a helpful message" do
          post :create, params: message_params
          expect(flash[:notice]).to eq("Message sent!")
        end

        it "creates a new message" do
          expect {
            post :create, params: message_params
          }.to change{user.messages.count}.by(1)
        end

        it "sends the message" do
          expect {
            post :create, params: message_params
          }.to change{FakeMessaging.messages.count}.by(1)
        end
      end

      context "unsubscribed" do
        let(:user) { create(:user, subscribed: false, organization: organization) }

        it "provides a helpful alert message" do
          post :create, params: message_params
          expect(flash[:alert]).to eq("Unfortunately they are unsubscribed! You can't text unsubscribed candidates using Chirpyhire.")
        end

        it "does not create a new message" do
          expect {
            post :create, params: message_params
          }.not_to change{user.messages.count}
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
