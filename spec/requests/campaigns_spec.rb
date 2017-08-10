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

    context 'active campaign' do
      context 'pausing' do
        let(:params) do
          {
            campaign: {
              status: :paused
            }
          }
        end

        it 'calls the CampaignPauserJob' do
          expect(CampaignPauserJob).to receive(:perform_later)

          put engage_auto_campaign_path(campaign), params: params
        end

        it 'sets last_paused_at' do
          expect {
            put engage_auto_campaign_path(campaign), params: params
          }.to change { campaign.reload.last_paused_at }.from(nil)
        end
      end
    end

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

        it 'calls the CampaignActivatorJob' do
          expect(CampaignActivatorJob).to receive(:perform_later)

          put engage_auto_campaign_path(campaign), params: params
        end
      end
    end
  end
end
