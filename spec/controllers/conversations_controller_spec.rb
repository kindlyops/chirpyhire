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
      let!(:oldest_message) { create(:message, user: admin) }
      let!(:second_oldest_message) { create(:message, user: admin, parent: oldest_message) }
      let!(:message) { create(:message, user: admin, parent: second_oldest_message) }

      it "returns the user's last message" do
        get :index, params: params
        expect(assigns(:conversations)).to match_array([message])
      end

      context "with other users on the same organization" do
        let(:user) { create(:user, organization: organization) }
        let!(:other_old_message) { create(:message, user: user) }
        let!(:other_message) { create(:message, user: user, parent: other_old_message) }

        it "includes the last message of the user" do
          get :index, params: params
          expect(assigns(:conversations)).to match_array([message, other_message])
        end

        context "order" do
          before(:each) do
            message.update(external_created_at: 4.days.ago)
            other_message.update(external_created_at: 2.days.ago)
          end

          it "shows the most recent conversations first" do
            get :index, params: params
            expect(assigns(:conversations)).to eq([other_message, message])
          end
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
