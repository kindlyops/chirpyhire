require 'rails_helper'

RSpec.describe Conversations::MessagesController do
  let(:team) { create(:team, :account) }
  let(:contact) { create(:contact, team: team) }
  let(:organization) { team.organization }
  let(:account) { team.accounts.first }
  let(:inbox) { account.inbox }
  let(:conversation) { contact.open_conversation }

  before do
    @request.env['HTTP_ACCEPT'] = 'application/json'
    sign_in(account)
  end

  describe '#index' do
    let(:params) {
      { conversation_id: conversation.id }
    }

    before do
      IceBreaker.call(contact)
    end

    let(:inbox_conversation) { account.inbox_conversations.find_by(conversation: conversation) }
    let!(:unread_receipts) { create_list(:read_receipt, 3, inbox_conversation: inbox_conversation) }

    context 'with outstanding read receipts for the conversation' do
      context 'impersonating' do
        let(:impersonator) { create(:account, super_admin: true) }

        before do
          sign_out(account)
          sign_in(impersonator)
          controller.impersonate_account(account)
        end

        it 'does not mark the read receipts as read' do
          expect {
            get :index, params: params
          }.not_to change { inbox_conversation.reload.read_receipts.unread.count }

          expect(inbox_conversation.read_receipts.unread.count).to eq(3)
        end
      end

      context 'not impersonating' do
        it 'marks the read receipts as read' do
          expect {
            get :index, params: params
          }.to change { inbox_conversation.reload.read_receipts.unread.count }.from(3).to(0)
        end
      end
    end
  end

  describe '#create' do
    let!(:params) do
      {
        conversation_id: conversation.id,
        message: {
          body: 'BODY'
        }
      }
    end

    context 'and the contact is active' do
      before do
        contact.update(subscribed: true)
      end

      it 'creates a message' do
        expect {
          post :create, params: params, xhr: true
        }.to change { contact.messages.count }.by(1)
      end

      it 'is a author organization message' do
        post :create, params: params, xhr: true
        expect(contact.messages.last.author).to eq(:organization)
      end

      it 'is sent from the account' do
        post :create, params: params, xhr: true
        expect(contact.messages.last.sender).to eq(account.person)
      end

      it 'is received by the person' do
        post :create, params: params, xhr: true
        expect(contact.messages.last.recipient).to eq(contact.person)
      end

      it 'sends a message' do
        expect {
          post :create, params: params, xhr: true
        }.to change { FakeMessaging.messages.count }.by(1)
      end

      context 'and the conversation is closed' do
        before do
          contact.conversations.each { |c| c.update(state: 'Closed') }
        end

        it 'does not create a message' do
          expect {
            post :create, params: params, xhr: true
          }.not_to change { contact.messages.count }
        end

        it 'does not send a message' do
          expect {
            post :create, params: params, xhr: true
          }.not_to change { FakeMessaging.messages.count }
        end
      end
    end

    context 'and the contact is not active' do
      it 'does not create a message' do
        expect {
          post :create, params: params, xhr: true
        }.not_to change { contact.messages.count }
      end

      it 'does not send a message' do
        expect {
          post :create, params: params, xhr: true
        }.not_to change { FakeMessaging.messages.count }
      end

      it 'lets the user know why' do
        post :create, params: params, xhr: true
        expect(response_json['error']).to include('unsubscribed')
      end
    end
  end
end
