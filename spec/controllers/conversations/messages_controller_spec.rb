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
    IceBreaker.call(contact)
  end

  describe '#index' do
    let(:params) {
      { conversation_id: conversation.id }
    }

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
end
