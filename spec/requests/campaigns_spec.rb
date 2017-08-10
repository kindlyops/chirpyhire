require 'rails_helper'

RSpec.describe 'Campaigns' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  describe 'update' do
    let(:campaign) { create(:campaign, organization: organization) }
    let!(:bot_campaign) { create(:bot_campaign, campaign: campaign) }

    context 'paused campaign' do
      before do
        campaign.update(status: :paused)
      end

      context 'activating' do
        let(:params) do
          {
            campaign: {
              status: :active
            }
          }
        end

        it 'calls the Campaign::Activator' do
          expect(Campaign::Activator).to receive(:call)

          put engage_auto_campaign_path(campaign), params: params
        end
      end
    end
  end
end
