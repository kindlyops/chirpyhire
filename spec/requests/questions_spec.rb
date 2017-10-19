require 'rails_helper'

RSpec.describe 'Questions' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }
  let!(:bot) { create(:bot, :question, organization: organization) }

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

        it 'does not create a new tag' do
          expect {
            post engage_auto_bot_questions_path(bot), params: params
          }.not_to change { Tag.count }
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

  describe 'destroy' do
    let!(:question) { bot.questions.first }

    context 'with other bot questions' do
      let!(:other_question) { create(:question, bot: bot, rank: 2) }

      it 'destroys the question' do
        expect {
          delete engage_auto_bot_question_path(bot, question)
        }.to change { bot.questions.count }.by(-1)
      end

      it 'destroys the question action' do
        expect {
          delete engage_auto_bot_question_path(bot, question)
        }.to change { bot.reload.actions.count }.by(-1)
      end

      it 'changes the other question ranks' do
        expect {
          delete engage_auto_bot_question_path(bot, question)
        }.to change { other_question.reload.rank }.from(2).to(1)
      end

      context 'with follow up' do
        let!(:follow_up) { bot.questions.first.follow_ups.first }
        let!(:action) { bot.next_question_action }
        before do
          question.create_action(type: 'QuestionAction', bot: bot)
          follow_up.update(action: question.action)
        end

        it 'migrates the follow up' do
          expect {
            delete engage_auto_bot_question_path(bot, question), params: { bot_action_id: action.id }
          }.to change { follow_up.reload.action }.from(question.action).to(action)
        end
      end
    end

    context 'without other bot questions' do
      it 'does not destroy the question' do
        expect {
          delete engage_auto_bot_question_path(bot, question)
        }.not_to change { bot.goals.count }
      end
    end
  end
end
