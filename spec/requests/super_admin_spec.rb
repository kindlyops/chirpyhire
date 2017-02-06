require 'rails_helper'

RSpec.describe 'Super Admin' do
  context 'as a super admin' do
    let!(:account) { create(:account, super_admin: true) }

    before do
      sign_in(account)
    end

    context 'impersonating another account' do
      let!(:other_account) { create(:account) }

      it 'is ok' do
        expect {
          get "/admin/account/#{other_account.id}/impersonate"
        }.not_to raise_error
      end
    end
  end
end
