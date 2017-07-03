require 'rails_helper'

RSpec.describe Bot::FollowUpTrigger do
  let(:bot) { create(:bot, :question) }
  let(:goal) { bot.goals.first }
  let(:question) { bot.questions.first }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:message) { create(:message) }
  let(:contact) { message.contact }
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
        it 'triggers the next question' do
          allow(bot).to receive(:question_after) { another_question }
          expect(another_question).to receive(:trigger) { another_question.body }

          subject.call
        end

        it 'includes the next question body' do
          allow(bot).to receive(:question_after) { another_question }
          allow(another_question).to receive(:trigger) { another_question.body }

          expect(subject.call).to include(another_question.body)
        end
      end

      context 'follow_up question' do
        let!(:third_question) { create(:choice_question, bot: bot) }
        before do
          follow_up.update(action: :question, question: third_question)
        end

        it 'triggers the third question' do
          allow(campaign_contact).to receive(:question) { third_question }
          expect(third_question).to receive(:trigger) { third_question.body }

          subject.call
        end

        it 'includes the third question body' do
          allow(campaign_contact).to receive(:question) { third_question }
          allow(third_question).to receive(:trigger) { third_question.body }

          expect(subject.call).to include(third_question.body)
        end
      end

      context 'follow_up goal' do
        before do
          follow_up.update(action: :goal, goal: goal)
        end

        it 'triggers the goal' do
          allow(subject).to receive(:goal) { goal }
          expect(goal).to receive(:trigger) { goal.body }

          subject.call
        end

        it 'includes the goal body' do
          allow(subject).to receive(:goal) { goal }
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
        before do
          follow_up.tags << create_list(:tag, rand(2..4))
        end

        it 'adds the tags to the contact' do
          allow(bot).to receive(:question_after) { another_question }
          allow(another_question).to receive(:trigger) { another_question.body }

          expect {
            subject.call
          }.to change { contact.reload.tags.count }.by(follow_up.tags.count)
        end
      end
    end
  end
end
