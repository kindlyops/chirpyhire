require 'rails_helper'

RSpec.describe ContactsController do
  describe '#update' do
    let(:contact) { create(:contact, screened: false) }
    let(:account) { create(:account, organization: contact.organization) }
    let(:params) {
      {
        id: contact.id,
        contact: {
          screened: true
        }
      }
    }

    before do
      sign_in(account)
    end

    context 'screened' do
      it 'allows the user to change the screened status of a contact' do
        expect {
          put :update, params: params, format: :json
        }.to change { contact.reload.screened? }.from(false).to(true)
      end
    end
  end
end
