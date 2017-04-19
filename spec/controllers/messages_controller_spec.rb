require 'rails_helper'

RSpec.describe MessagesController do
  describe '#create' do
    let(:contact) { create(:contact) }
    let(:organization) { contact.organization }
    let(:account) { create(:account, organization: organization) }

    let(:params) do
      {
        contact_id: contact.id,
        message: {
          body: 'BODY'
        }
      }
    end

    before do
      sign_in(account)
    end

    context 'and the contact is active' do
      before do
        contact.update(subscribed: true)
      end

      it 'creates a message' do
        expect {
          post :create, params: params, xhr: true
        }.to change { organization.messages.count }.by(1)
      end

      it 'is a author organization message' do
        post :create, params: params, xhr: true
        expect(organization.messages.last.author).to eq(:organization)
      end

      it 'is sent from the account' do
        post :create, params: params, xhr: true
        expect(organization.messages.last.sender).to eq(account.person)
      end

      it 'is received by the person' do
        post :create, params: params, xhr: true
        expect(organization.messages.last.recipient).to eq(contact.person)
      end

      it 'sends a message' do
        expect {
          post :create, params: params, xhr: true
        }.to change { FakeMessaging.messages.count }.by(1)
      end
    end

    context 'and the contact is not active' do
      it 'does not create a message' do
        expect {
          post :create, params: params, xhr: true
        }.not_to change { organization.messages.count }
      end

      it 'does not send a message' do
        expect {
          post :create, params: params, xhr: true
        }.not_to change { FakeMessaging.messages.count }
      end

      it 'lets the user know why' do
        post :create, params: params, xhr: true
        expect(flash[:alert]).to include('unsubscribed')
      end
    end
  end
end
