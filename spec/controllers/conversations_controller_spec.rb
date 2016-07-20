require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
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

    context "with messages" do
      it "returns the user's last message" do
        messages = create_list(:message, 3, user: admin)

        get :index, params: params
        expect(assigns(:conversations)).to match_array([messages.last])
      end

      context "order" do
        let(:other_user) { create(:user, organization: organization) }
        let!(:old_message) { create(:message, id: 10, user: admin) }
        let!(:recent_message) { create(:message, id: 11, user: other_user) }

        it "sorts by ID desc" do
          get :index, params: params
          expect(assigns(:conversations)).to eq([recent_message, old_message])
        end
      end

      context "with other users on the same organization" do
        let(:user) { create(:user, organization: organization) }
        let!(:other_messages) { create_list(:message, 2, user: user) }

        it "includes the last message of the user" do
          messages = create_list(:message, 3, user: admin)
          get :index, params: params
          expect(assigns(:conversations)).to match_array([messages.last, other_messages.last])
        end
      end

      context "with other organizations" do
        let!(:other_messages) { create_list(:message, 2) }
        it "does not return the other organization's messages" do
          get :index, params: params
          expect(assigns(:conversations)).not_to include(other_messages)
        end
      end
    end
  end
end
