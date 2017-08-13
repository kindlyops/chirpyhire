require 'rails_helper'

RSpec.describe 'Goals' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }
  let(:bot) { create(:bot, organization: organization) }

  before do
    sign_in(account)
  end

  describe 'create' do
    let(:params) do
      {
        goal: {
          body: Faker::Lorem.sentence 
        }
      }
    end

    context 'bot not active' do
      it 'does create a goal' do
        expect {
          post engage_auto_bot_goals_path(bot), params: params
        }.to change { bot.reload.goals.count }.by(1)
      end

      it 'does create a bot action' do
        expect {
          post engage_auto_bot_goals_path(bot), params: params
        }.to change { bot.reload.actions.count }.by(1)
      end
    end

    context 'bot active' do
      let!(:bot_campaign) { create(:bot_campaign, bot: bot) }

      it 'does not create a goal' do
        expect {
          post engage_auto_bot_goals_path(bot), params: params
        }.not_to change { bot.reload.goals.count }
      end

      it 'does not create a bot action' do
        expect {
          post engage_auto_bot_goals_path(bot), params: params
        }.not_to change { bot.reload.actions.count }
      end
    end
  end
end
