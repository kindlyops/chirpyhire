# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before do
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
      let!(:oldest_message) { create(:message, user: user) }
      let!(:second_oldest_message) { create(:message, user: user) }
      let!(:message) { create(:message, user: user) }

      before do
        oldest_message.update(child: second_oldest_message)
        second_oldest_message.update(child: message)
      end

      it "returns the user's last message" do
        get :index, params: params
        expect(assigns(:conversations)).to match_array([message])
      end

      context 'with other users on the same organization' do
        let(:user) { create(:user, organization: organization) }
        let!(:other_old_message) { create(:message, user: user) }
        let!(:other_message) { create(:message, user: user) }

        before do
          other_old_message.update(child: other_message)
        end

        it 'includes the last message of the user' do
          get :index, params: params
          expect(assigns(:conversations)).to match_array([message, other_message])
        end

        context 'order' do
          before do
            message.update(external_created_at: 4.days.ago)
            other_message.update(external_created_at: 2.days.ago)
          end

          it 'shows the most recent conversations first' do
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
