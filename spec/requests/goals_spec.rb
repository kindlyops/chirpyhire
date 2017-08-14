require 'rails_helper'

RSpec.describe 'Goals' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }
  let(:bot) { create(:bot, :question, organization: organization) }

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

  describe 'destroy' do
    let!(:goal) { bot.goals.first }

    context 'with other bot goals' do
      let!(:other_goal) { create(:goal, bot: bot, rank: 2) }

      it 'destroys the goal' do
        expect {
          delete engage_auto_bot_goal_path(bot, goal)
        }.to change { bot.goals.count }.by(-1)
      end

      it 'changes the other goal ranks' do
        expect {
          delete engage_auto_bot_goal_path(bot, goal)
        }.to change { other_goal.reload.rank }.from(2).to(1)
      end

      context 'with follow up' do
        let!(:follow_up) { bot.questions.first.follow_ups.first }
        let!(:action) { bot.next_question_action }
        before do
          goal.create_action(type: 'GoalAction', bot: bot)
          follow_up.update(action: goal.action)
        end

        it 'migrates the follow up' do
          expect {
            delete engage_auto_bot_goal_path(bot, goal), params: { bot_action_id: action.id }
          }.to change { follow_up.reload.action }.from(goal.action).to(action)
        end
      end
    end

    context 'without other bot goals' do
      it 'does not destroy the goal' do
        expect {
          delete engage_auto_bot_goal_path(bot, goal)
        }.not_to change { bot.goals.count }
      end
    end
  end
end
