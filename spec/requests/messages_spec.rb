require 'rails_helper'

RSpec.describe 'Messages' do
  let(:account) { create(:account, :team) }
  let(:team) { account.teams.first }

  before do
    sign_in(account)
  end

  context 'without any caregivers' do
    it 'redirects to the home page' do
      get messages_path
      expect(response).to redirect_to(root_path)
    end

    it 'lets the user know there are no caregivers to message' do
      get messages_path
      follow_redirect!
      expect(response.body).to include('No caregivers to message yet.')
    end
  end

  context 'with caregivers' do
    let!(:current_contact) { create(:contact, team: team) }
    let!(:with_unread_messages) { create(:contact, team: team) }

    before do
      IceBreaker.call(current_contact)
      IceBreaker.call(with_unread_messages)
      with_unread_messages.conversations.each { |c| c.update(unread_count: 1) }
    end

    context 'with a current conversation' do
      before do
        get message_path(current_contact)
      end

      it 'redirects to the current conversation' do
        get messages_path
        expect(response).to redirect_to(message_path(current_contact))
      end
    end

    context 'without a current conversation' do
      it 'redirects to the caregiver with unread messages' do
        get messages_path
        expect(response).to redirect_to(message_path(with_unread_messages))
      end
    end
  end
end
