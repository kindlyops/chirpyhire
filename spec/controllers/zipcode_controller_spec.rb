require 'rails_helper'

RSpec.describe ZipcodeController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe '#geo_json' do
    context 'with a zipcode that exists', vcr: { cassette_name: 'ZipcodeController#zipcode' } do
      it 'returns data' do
        get :geo_json, params: { zipcode: '02150' }
        expect(response.body).not_to be(nil)
      end
    end
    context "with a zipcode that doesn't exist.", vcr: { cassette_name: 'ZipcodeController#zipcode_nonexistent' } do
      it 'does not return data' do
        get :geo_json, params: { zipcode: 'NR17' }
        expect(response.body).to eq("")
      end
      it 'logs the missing zipcode' do
        get :geo_json, params: { zipcode: 'NR17' }
        expect(Logging::Logger.logged_messages.count).to eq(1)
      end
    end
  end
end
