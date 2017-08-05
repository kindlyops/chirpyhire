require 'rails_helper'

RSpec.describe Bot::Greet do
  let(:bot) { create(:bot) }
  let(:goal) { bot.goals.first }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:message) { create(:message, :conversation_part) }
  let(:contact) { message.contact }
  let(:campaign_contact) { create(:campaign_contact, contact: contact, campaign: campaign) }

  subject { Bot::Greet.new(bot, message, campaign_contact) }

  describe '#call' do
    context 'pending campaign_contact' do
      it 'sets the campaign contact to active' do
        allow(subject).to receive(:goal) { goal }
        allow(goal).to receive(:trigger) { goal.body }

        expect {
          subject.call
        }.to change { campaign_contact.reload.state }.from('pending').to('active')
      end

      it 'includes the bot greeting' do
        allow(subject).to receive(:goal) { goal }
        allow(goal).to receive(:trigger) { goal.body }

        expect(subject.call).to include(bot.greeting.body)
      end

      context 'bot has questions' do
        let!(:question) { create(:choice_question, bot: bot) }

        it 'triggers the question' do
          allow(subject).to receive(:first_active_question) { question }
          expect(question).to receive(:trigger) { question.body }

          subject.call
        end

        it 'includes the question body' do
          allow(subject).to receive(:first_active_question) { question }
          allow(question).to receive(:trigger) { question.body }

          expect(subject.call).to include(question.body)
        end
      end

      context 'bot has no questions' do
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
    end
  end
end
