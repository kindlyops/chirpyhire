require 'rails_helper'

RSpec.describe 'Questions' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }
  let(:bot) { create(:bot, organization: organization) }

  before do
    sign_in(account)
  end

  describe 'create' do
    let(:params) do
      {
        question: {
          body: Faker::Lorem.sentence,
          follow_ups_attributes: {
            '123122141390219301' => {
              body: Faker::Lorem.sentence,
              response: Faker::Lorem.sentence,
              bot_action_id: bot.actions.first.id,
              rank: 1
            }
          }
        }
      }
    end
    
    context 'bot not active' do
      it 'does create a question' do
        expect {
          post engage_auto_bot_questions_path(bot), params: params
        }.to change { bot.reload.questions.count }.by(1)
      end

      it 'does create a bot action' do
        expect {
          post engage_auto_bot_questions_path(bot), params: params
        }.to change { bot.reload.actions.count }.by(1)
      end

      it 'does create a follow up' do
        expect {
          post engage_auto_bot_questions_path(bot), params: params
        }.to change { FollowUp.count }.by(1)
      end

      context 'with existing tag' do
        let!(:tag) { create(:tag, organization: organization) }
        let(:params) do
          {
            question: {
              body: Faker::Lorem.sentence,
              follow_ups_attributes: {
                '123122141390219301' => {
                  body: Faker::Lorem.sentence,
                  response: Faker::Lorem.sentence,
                  bot_action_id: bot.actions.first.id,
                  tags: [tag.name],
                  rank: 1
                }
              }
            }
          }
        end

        it 'does tie the follow up to the tag' do
          post engage_auto_bot_questions_path(bot), params: params
          expect(FollowUp.last.tags.first).to eq(tag)
        end
      end

      context 'with new tag' do
        let(:params) do
          {
            question: {
              body: Faker::Lorem.sentence,
              follow_ups_attributes: {
                '123122141390219301' => {
                  body: Faker::Lorem.sentence,
                  response: Faker::Lorem.sentence,
                  bot_action_id: bot.actions.first.id,
                  tags: ['new tag'],
                  rank: 1
                }
              }
            }
          }
        end

        it 'does tie the follow up to the tag' do
          post engage_auto_bot_questions_path(bot), params: params
          expect(FollowUp.last.tags.first.name).to eq('new tag')
        end

        it 'creates a new tag' do
          expect {
            post engage_auto_bot_questions_path(bot), params: params
            }.to change { organization.reload.tags.count }.by(1)
        end
      end

      context 'with multiple follow ups' do
        let(:params) do
          {
            question: {
              body: Faker::Lorem.sentence,
              follow_ups_attributes: {
                '123122141390219301' => {
                  body: Faker::Lorem.sentence,
                  response: Faker::Lorem.sentence,
                  bot_action_id: bot.actions.first.id,
                  rank: 1
                },
                '123122141390219302' => {
                  body: Faker::Lorem.sentence,
                  response: Faker::Lorem.sentence,
                  bot_action_id: bot.actions.first.id,
                  rank: 2
                }
              }
            }
          }
        end

        it 'does creates two follow up' do
          expect {
            post engage_auto_bot_questions_path(bot), params: params
          }.to change { FollowUp.count }.by(2)
        end
      end

      context 'without follow ups' do
        let(:params) do
          {
            question: {
              body: Faker::Lorem.sentence
            }
          }
        end

        it 'does not create a question' do
          expect {
            post engage_auto_bot_questions_path(bot), params: params
          }.not_to change { bot.reload.questions.count }
        end

        it 'does not create a bot action' do
          expect {
            post engage_auto_bot_questions_path(bot), params: params
          }.not_to change { bot.reload.actions.count }
        end
      end
    end

    context 'bot active' do
      let!(:bot_campaign) { create(:bot_campaign, bot: bot) }

      it 'does not create a question' do
        expect {
          post engage_auto_bot_questions_path(bot), params: params
        }.not_to change { bot.reload.questions.count }
      end

      it 'does not create a bot action' do
        expect {
          post engage_auto_bot_questions_path(bot), params: params
        }.not_to change { bot.reload.actions.count }
      end
    end
  end
end
