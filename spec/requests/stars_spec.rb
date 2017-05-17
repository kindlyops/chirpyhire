require 'rails_helper'

RSpec.describe 'Stars' do
  let(:account) { create(:account, :team) }

  before do
    sign_in(account)
  end

  describe '#create' do
    let!(:contact) { create(:contact, organization: account.organization) }

    it 'redirects to messages path' do
      post contact_star_path(contact)

      expect(response).to redirect_to(message_path(contact))
    end

    context 'contact starred' do
      before do
        contact.update!(starred: true)
      end

      it 'marks the contact as unstarred' do
        expect {
          post contact_star_path(contact)
        }.to change { contact.reload.starred? }.from(true).to(false)
      end
    end

    context 'contact unstarred' do
      before do
        contact.update!(starred: false)
      end

      it 'marks the contact as starred' do
        expect {
          post contact_star_path(contact)
        }.to change { contact.reload.starred? }.from(false).to(true)
      end
    end
  end
end
