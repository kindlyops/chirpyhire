require 'rails_helper'

RSpec.describe MessagesController do
  describe '#create' do
    let(:subscriber) { create(:subscriber) }
    let(:organization) { subscriber.organization }
    let(:account) { create(:account, organization: organization) }

    let(:params) do
      {
        subscriber_id: subscriber.id,
        message: {
          body: 'BODY'
        }
      }
    end

    before do
      sign_in(account)
    end

    context 'and the subscriber is active' do
      it 'creates a message' do
        expect {
          post :create, params: params
        }.to change { organization.messages.count }.by(1)
      end

      it 'is a manual message' do
        post :create, params: params
        expect(organization.messages.last.manual?).to eq(true)
      end

      it 'sends a message' do
        expect {
          post :create, params: params
        }.to change { FakeMessaging.messages.count }.by(1)
      end
    end

    context 'and the subscriber is not active' do
      before do
        subscriber.update(subscribed: false)
      end

      it 'does not create a message' do
        expect {
          post :create, params: params
        }.not_to change { organization.messages.count }
      end

      it 'does not send a message' do
        expect {
          post :create, params: params
        }.not_to change { FakeMessaging.messages.count }
      end

      it 'lets the user know why' do
        post :create, params: params
        expect(flash[:alert]).to include('unsubscribed')
      end
    end
  end
end
