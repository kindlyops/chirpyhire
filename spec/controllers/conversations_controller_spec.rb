require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }
  let!(:candidate) { create(:candidate, user: user) }
  before(:each) do
    sign_in(account)
  end

  let(:params) do
    { user_id: user.id }
  end

  describe '#index' do
    it 'is OK' do
      get :index, params: params
      expect(response).to be_ok
    end

    context 'with messages' do
      let!(:oldest_message) { create(:message, user: user, external_created_at: 7.days.ago) }
      let!(:second_oldest_message) { create(:message, user: user, external_created_at: 6.days.ago) }
      let!(:message) { create(:message, user: user) }

      it "returns the user's last message" do
        get :index, params: params
        expect(assigns(:conversations)).to match_array([message])
      end

      context 'with other users on the same organization' do
        let(:user2) { create(:user, :with_candidate, organization: organization) }
        let!(:other_old_message) { create(:message, user: user2, external_created_at: 5.days.ago) }
        let!(:other_message) { create(:message, user: user2) }

        it 'includes the last message of the user' do
          get :index, params: params
          expect(assigns(:conversations)).to match_array([message, other_message])
        end

        context 'order' do
          before(:each) do
            message.update(external_created_at: 4.days.ago)
            other_message.update(external_created_at: 2.days.ago)
          end

          it 'shows the most <r></r>ecent conversations first' do
            get :index, params: params
            expect(assigns(:conversations)).to eq([other_message, message])
          end
        end
      end

      context 'with other organizations' do
        let!(:other_messages) { create_list(:message, 2) }
        it "does not return the other organization's messages" do
          get :index, params: params
          expect(assigns(:conversations)).not_to include(other_messages)
        end
      end
    end
  end
end
