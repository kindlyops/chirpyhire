require 'rails_helper'

RSpec.describe 'Conversations' do
  let(:account) { create(:account, :inbox, :team_with_phone_number) }
  let(:inbox) { account.inbox }
  let(:team) { account.teams.first }

  before do
    sign_in(account)
  end

  context 'without any caregivers' do
    it 'provides a useful empty state message' do
      get inbox_conversations_path(inbox)
      expect(response.body).to include('No one to message yet...')
    end
  end

  context 'with caregivers' do
    let!(:current_contact) { create(:contact, team: team) }
    let!(:with_unread_messages) { create(:contact, team: team) }
    let(:current_conversation) { inbox.conversation(current_contact) }

    before do
      IceBreaker.call(current_contact)
      IceBreaker.call(with_unread_messages)
      with_unread_messages.inbox_conversations.each { |c| c.update(unread_count: 1) }
    end

    context 'with a current conversation' do
      before do
        get inbox_conversation_path(inbox, current_conversation)
      end

      it 'redirects to the current conversation' do
        get inbox_conversations_path(inbox)
        expect(response).to redirect_to(inbox_conversation_path(inbox, current_conversation))
      end
    end

    context 'without a current conversation' do
      let(:unread_conversation) { inbox.conversation(with_unread_messages) }

      it 'redirects to the caregiver with unread messages' do
        get inbox_conversations_path(inbox)
        expect(response).to redirect_to(inbox_conversation_path(inbox, unread_conversation))
      end
    end
  end
end
