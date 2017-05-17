require 'rails_helper'

RSpec.describe MessagesController do
  let(:contact) { create(:contact) }
  let(:organization) { contact.organization }
  let(:account) { create(:account, organization: organization) }

  before do
    sign_in(account)
    IceBreaker.call(contact)
  end

  describe '#create' do
    let(:params) do
      {
        contact_id: contact.id,
        message: {
          body: 'BODY'
        }
      }
    end

    context 'and the contact is active' do
      before do
        contact.update(subscribed: true)
      end

      context 'and the contact and account are on the same team' do
        before do
          team = create(:team, organization: organization)
          team.accounts << account
          contact.update(team: account.teams.first)
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

      context 'and the account and contact are not on the same team' do
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

  describe '#show' do
    let(:params) {
      { contact_id: contact.id }
    }
    let(:conversation) { account.conversations.find_by(contact: contact) }
    let!(:unread_receipts) { create_list(:read_receipt, 3, conversation: conversation) }

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
            get :show, params: params
          }.not_to change { conversation.reload.read_receipts.unread.count }

          expect(conversation.read_receipts.unread.count).to eq(3)
        end
      end

      context 'not impersonating' do
        it 'marks the read receipts as read' do
          expect {
            get :show, params: params
          }.to change { conversation.reload.read_receipts.unread.count }.from(3).to(0)
        end
      end
    end
  end
end
