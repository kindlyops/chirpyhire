require 'rails_helper'

RSpec.describe Bot::FollowUpTrigger do
  let(:bot) { create(:bot, :question) }
  let(:goal) { bot.goals.first }
  let(:question) { bot.questions.first }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:contact) { create(:contact, organization: bot.organization) }
  let(:conversation) { create(:conversation, contact: contact) }
  let(:conversation_part) { create(:conversation_part, conversation: conversation) }
  let(:message) { create(:message, conversation_part: conversation_part) }
  let(:campaign_contact) { create(:campaign_contact, contact: contact, campaign: campaign) }
  let(:follow_up) { create(:choice_follow_up, question: question) }

  subject { Bot::FollowUpTrigger.new(follow_up, message, campaign_contact) }

  describe '#call' do
    context 'follow up not activated' do
      before do
        allow(follow_up).to receive(:activated?) { false }
      end

      it 'is empty' do
        expect(subject.call).to eq('')
      end
    end

    context 'follow up activated' do
      let!(:another_question) { create(:choice_question, bot: bot) }
      before do
        allow(follow_up).to receive(:activated?) { true }
      end

      it 'includes the follow_up body' do
        allow(bot).to receive(:question_after) { another_question }
        allow(another_question).to receive(:trigger) { another_question.body }

        expect(subject.call).to include(follow_up.body)
      end

      context 'with another question' do
        before do
          allow(bot).to receive(:question_after) { another_question }
        end

        it 'triggers the next question' do
          expect(another_question).to receive(:trigger) { another_question.body }

          subject.call
        end

        it 'includes the next question body' do
          allow(another_question).to receive(:trigger) { another_question.body }

          expect(subject.call).to include(another_question.body)
        end
      end

      context 'without another question' do
        before do
          allow(bot).to receive(:question_after) { nil }
        end

        it 'triggers the goal' do
          allow(subject).to receive(:first_goal) { goal }
          expect(goal).to receive(:trigger) { goal.body }

          subject.call
        end

        it 'includes the goal body' do
          allow(subject).to receive(:first_goal) { goal }
          allow(goal).to receive(:trigger) { goal.body }
          expect(subject.call).to include(goal.body)
        end
      end

      context 'follow_up question' do
        let!(:third_question) { create(:choice_question, bot: bot) }
        let(:question_action) { create(:question_action, question: third_question, bot: bot) }

        before do
          follow_up.update(action: question_action)
          allow(subject).to receive(:action_question) { third_question }
        end

        it 'triggers the third question' do
          expect(third_question).to receive(:trigger) { third_question.body }

          subject.call
        end

        it 'includes the third question body' do
          allow(third_question).to receive(:trigger) { third_question.body }

          expect(subject.call).to include(third_question.body)
        end
      end

      context 'follow_up goal' do
        let(:goal_action) { create(:goal_action, goal: goal, bot: bot) }

        before do
          follow_up.update(action: goal_action)
          allow(subject).to receive(:action_goal) { goal }
        end

        it 'triggers the goal' do
          expect(goal).to receive(:trigger) { goal.body }

          subject.call
        end

        it 'includes the goal body' do
          allow(goal).to receive(:trigger) { goal.body }
          expect(subject.call).to include(goal.body)
        end
      end

      it 'broadcasts the contact' do
        allow(bot).to receive(:question_after) { another_question }
        allow(another_question).to receive(:trigger) { another_question.body }
        expect(Broadcaster::Contact).to receive(:broadcast)

        subject.call
      end

      context 'with tags' do
        let(:tags) { create_list(:tag, rand(2..4), organization: bot.organization) }

        before do
          follow_up.tags << tags
          allow(bot).to receive(:question_after) { another_question }
          allow(another_question).to receive(:trigger) { another_question.body }
        end

        context 'and the tags are already on the contact' do
          before do
            contact.tags << tags
          end

          it 'does not raise error' do
            expect {
              subject.call
            }.not_to raise_error
          end
        end

        it 'adds the tags to the contact' do
          expect {
            subject.call
          }.to change { contact.reload.tags.count }.by(follow_up.tags.count)
        end
      end
    end
  end
end
