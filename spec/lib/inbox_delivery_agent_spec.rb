require 'rails_helper'

RSpec.describe InboxDeliveryAgent do
  describe 'call' do
    subject { InboxDeliveryAgent.new(inbox, message) }

    context 'with a bot tied to the inbox' do
      let(:bot) { create(:bot) }
      let(:bot_campaign) { create(:bot_campaign, bot: bot) }
      let!(:inbox) { bot_campaign.inbox }

      context 'and the contact is not in a campaign for the bot' do
        context 'and the message would trigger the bot (START)' do
          let!(:message) { create(:message, body: 'start') }

          it 'calls BotDeliveryAgent' do
            expect(BotDeliveryAgent).to receive(:call).with(bot, message)

            subject.call
          end
        end

        context 'and the message would not trigger the bot' do
          let!(:message) { create(:message, body: 'I am interested in work') }

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.call
          end
        end
      end

      context 'and the contact is in a campaign for the bot' do
        before do
          create(:campaign_contact, contact: message.conversation.contact)
        end

        context 'and the message is anything' do
          let!(:message) { create(:message) }

          it 'calls BotDeliveryAgent' do
            expect(BotDeliveryAgent).to receive(:call).with(bot, message)

            subject.call
          end
        end
      end
    end
  end
end
