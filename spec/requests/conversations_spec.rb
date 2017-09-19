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
        organization.subscription.update(internal_status: :canceled)
      end

      it 'redirects to billing' do
        get inbox_conversation_path(inbox, conversation)

        expect(response).to redirect_to organization_billing_company_path(organization)
      end
    end
  end

  describe 'update' do
    let(:contact) { create(:contact, :new, organization: organization) }
    let(:screened_stage) { create(:contact_stage, :screened, organization: organization) }
    let!(:conversation) { create(:conversation, inbox: inbox, contact: contact) }

    let(:params) do
      {
        conversation: {
          state: 'Closed',
          contact_attributes: {
            id: contact.id,
            contact_stage_id: screened_stage.id
          }
        }
      }
    end

    context 'changing the contact outcome' do
      it 'updates the conversation to closed' do
        expect {
          put inbox_conversation_path(inbox, conversation), params: params
        }.to change { conversation.reload.state }.from('Open').to('Closed')
      end

      it 'changes the contact outcome to Screened' do
        expect {
          put inbox_conversation_path(inbox, conversation), params: params
        }.to change { contact.reload.stage.name }.from('New').to('Screened')
      end
    end
  end
end
