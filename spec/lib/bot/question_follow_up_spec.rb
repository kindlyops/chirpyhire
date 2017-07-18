require 'rails_helper'

RSpec.describe Bot::QuestionFollowUp do
  let(:bot) { create(:bot, :question) }
  let(:question) { bot.questions.first }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:message) { create(:message) }
  let(:contact) { message.contact }
  let(:campaign_contact) { create(:campaign_contact, contact: contact, campaign: campaign) }

  subject { Bot::QuestionFollowUp.new(question, message, campaign_contact) }

  describe '#call' do
    context 'question has follow ups' do
      let(:response) { Faker::Lorem.word }
      let!(:follow_up) { create(:follow_up, response: response, question: question, rank: question.next_follow_up_rank) }

      context 'activated' do
        before do
          allow(subject).to receive(:follow_up) { follow_up }
        end

        it 'triggers the follow up' do
          expect(follow_up).to receive(:trigger) { follow_up.body }

          subject.call
        end

        it 'includes the follow up body' do
          allow(follow_up).to receive(:trigger) { follow_up.body }

          expect(subject.call).to include(follow_up.body)
        end

        it 'does not restate the question' do
          allow(follow_up).to receive(:trigger) { follow_up.body }
          expect(question).not_to receive(:restated)

          subject.call
        end

        it 'does not log the message' do
          allow(follow_up).to receive(:trigger) { follow_up.body }
          expect(ReadReceiptsCreator).not_to receive(:call)

          subject.call
        end
      end

      context 'not activated' do
        before do
          allow(subject).to receive(:follow_up) { nil }
        end

        it 'does restate the question' do
          expect(question).to receive(:restated)

          subject.call
        end

        it 'does log the message' do
          expect(ReadReceiptsCreator).to receive(:call)

          subject.call
        end
      end
    end
  end
end
