require 'rails_helper'

RSpec.describe 'Follow Ups' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  let(:bot) { create(:bot, organization: organization) }
  let(:question) { create(:question, bot: bot) }
  let!(:follow_up) { create(:follow_up, question: question) }

  describe 'updating' do
    let!(:new_tags) { [Faker::Name.name, Faker::Name.name] }
    let(:params) do
      {
        follow_up: {
          response: follow_up.response,
          body: follow_up.body,
          bot_action_id: follow_up.action.id,
          tags: new_tags
        }
      }
    end

    context 'tags' do
      let(:tag_1) { organization.tags.create(name: Faker::Name.name) }
      let(:tag_2) { organization.tags.create(name: Faker::Name.name) }
      let(:tag_3) { organization.tags.create(name: Faker::Name.name) }

      let!(:existing_tags) { [tag_1, tag_2, tag_3] }

      context 'with existing tags' do
        before do
          follow_up.tags << tag_1
          follow_up.tags << tag_2
          follow_up.tags << tag_3
        end

        context 'and they are deleted' do
          it 'deletes the tags' do
            put engage_auto_bot_question_follow_up_path(bot, question, follow_up), params: params
            expect(follow_up.reload.tags).not_to include(*existing_tags)
            expect(follow_up.reload.tags.pluck(:name)).to match_array(new_tags)
          end
        end
      end

      context 'tags is nil' do
        let!(:new_tags) { nil }

        it 'does not raise an error' do
          expect {
            put engage_auto_bot_question_follow_up_path(bot, question, follow_up), params: params
          }.not_to raise_error
        end

        it 'deletes the tags' do
          put engage_auto_bot_question_follow_up_path(bot, question, follow_up), params: params
          expect(follow_up.reload.tags).to eq([])
        end
      end

      context 'without existing tags' do
        context 'multiple' do
          it 'adds the tags' do
            put engage_auto_bot_question_follow_up_path(bot, question, follow_up), params: params
            expect(follow_up.reload.tags.pluck(:name)).to match_array(new_tags)
          end
        end
      end
    end
  end
end
