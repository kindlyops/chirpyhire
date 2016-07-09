require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:admin) { create(:user, :with_account, organization: organization) }

  before(:each) do
    sign_in(admin.account)
  end

  describe "#new" do
    context "xhr" do
      it "assigns a new message" do
        get :new, xhr: true, params: { user_id: user.id }

        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).not_to be_persisted
      end

      it "is ok" do
        get :new, xhr: true, params: { user_id: user.id }
        expect(response).to be_ok
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

    context "xhr" do
      it "creates a new message" do
        expect {
          post :create, xhr: true, params: message_params
        }.to change{user.messages.count}.by(1)
      end

      it "sends the message" do
        expect {
          post :create, xhr: true, params: message_params
        }.to change{FakeMessaging.messages.count}.by(1)
      end
    end
  end
end
