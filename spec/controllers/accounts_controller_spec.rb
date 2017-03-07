require 'rails_helper'

RSpec.describe AccountsController do
  describe '#stop_impersonating' do
    let(:impersonator) { create(:account, super_admin: true) }
    let(:impersonatee) { create(:account) }

    before do
      sign_in(impersonator)
    end

    context 'impersonating' do
      before do
        controller.impersonate_account(impersonatee)
      end

      it 'stops the impersonation' do
        post :stop_impersonating
        expect(controller.current_account).to eq(impersonator)
      end
    end
  end
end
