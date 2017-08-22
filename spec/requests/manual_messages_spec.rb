require 'rails_helper'

RSpec.describe 'Manual Messages' do
  let(:account) { create(:account, :person, :team_with_phone_number_and_inbox) }
  let(:organization) { account.organization }

  before do
    sign_in(account)
  end

  describe 'create' do
    let(:contact) { create(:contact, :name, organization: organization) }

    let(:params) do
      {
        manual_message: {
          title: 'Title',
          body: 'body',
          audience: {
            predicates: [{
              type: 'string', attribute: 'name', value: contact.name, comparison: 'cont'
            }]
          }
        }
      }
    end

    context 'with valid manual message' do
      it 'creates a manual message' do
        expect {
          post engage_manual_messages_path, params: params
        }.to change { account.reload.manual_messages.count }.by(1)
      end

      it 'creates the participants for the manual message' do
        expect {
          post engage_manual_messages_path, params: params
        }.to change { ManualMessageParticipant.count }.from(0).to(1)
      end

      it 'creates a ManualMessageJob' do
        expect(ManualMessageJob).to receive(:perform_later)
        post engage_manual_messages_path, params: params
      end

      context 'with multiple contacts' do
        let!(:other_contact) { create(:contact, name: contact.name, organization: organization) }

        it 'creates the participants for the manual message' do
          expect {
            post engage_manual_messages_path, params: params
          }.to change { ManualMessageParticipant.count }.from(0).to(2)
        end
      end
    end
  end
end
