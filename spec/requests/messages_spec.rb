require 'rails_helper'

RSpec.describe 'Messages' do
  let(:account) { create(:account, :inbox, :team_with_phone_number) }
  let(:inbox) { account.inbox }
  let(:team) { account.teams.first }

  before do
    sign_in(account)
  end

  describe 'index' do
    it 'redirects to the conversations path' do
      get messages_path

      expect(response).to redirect_to(inbox_conversations_path(inbox))
    end
  end

  describe 'show' do
    let(:contact) { create(:contact, team: team) }
    let(:conversation) { inbox.conversations.find_by(contact: contact) }
    before do
      IceBreaker.call(contact)
    end

    it 'redirects to the conversation path' do
      get message_path(contact)

      expect(response).to redirect_to(inbox_conversation_path(inbox, conversation))
    end
  end
end
