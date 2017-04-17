require 'rails_helper'

RSpec.describe 'Messages' do
  let(:account) { create(:account) }

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
    let!(:current_contact) { create(:contact, organization: account.organization) }
    let!(:most_recent_message_contact) { create(:contact, organization: account.organization) }

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
      it 'redirects to the caregiver who sent the last message' do
        get messages_path
        expect(response).to redirect_to(message_path(most_recent_message_contact))
      end
    end
  end
end
