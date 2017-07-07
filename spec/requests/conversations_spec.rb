require 'rails_helper'

RSpec.describe 'Conversations' do
  let(:organization) { create(:organization, :subscription, :team, :account) }
  let(:account) { organization.accounts.first }
  let!(:inbox) { organization.teams.first.inbox }

  before do
    sign_in(account)
  end

  describe 'show' do
    let(:contact) { create(:contact, organization: organization) }
    let!(:conversation) { create(:conversation, inbox: inbox, contact: contact) }

    describe 'canceled subscription' do
      before do
        organization.subscription.update(status: :canceled)
      end

      it 'redirects to billing' do
        get inbox_conversation_path(inbox, conversation)

        expect(response).to redirect_to organization_billing_company_path(organization)
      end
    end
  end
end
