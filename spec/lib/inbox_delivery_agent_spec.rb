require 'rails_helper'

RSpec.describe InboxDeliveryAgent do
  describe 'call' do
    subject { InboxDeliveryAgent.new(inbox, message) }

    context 'with a bot tied to the inbox' do
      let(:bot) { create(:bot) }
      let(:bot_campaign) { create(:bot_campaign, bot: bot) }
      let(:campaign) { bot_campaign.campaign }
      let!(:inbox) { bot_campaign.inbox }
      let(:conversation) { create(:conversation, inbox: inbox) }

      context 'and the conversation is not in an active campaign for the bot' do
        context 'and the message would trigger the bot (START)' do
          let!(:message) { create(:message, body: 'start', conversation: conversation) }

          it 'calls Bot::Receiver' do
            expect(Bot::Receiver).to receive(:call).with(bot, message)

            subject.call
          end
        end

        context 'and the message would not trigger the bot' do
          let!(:message) { create(:message, body: 'I am interested in work', conversation: conversation) }

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.call
          end
        end
      end

      context 'and the conversation is in an exited campaign for the bot' do
        before do
          create(:campaign_contact, state: :exited, campaign: campaign, contact: conversation.contact)
        end

        context 'and the message would trigger the bot' do
          let!(:message) { create(:message, body: 'start', conversation: conversation) }

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.call
          end

          it 'does not call Bot::Receiver' do
            expect(Bot::Receiver).not_to receive(:call)

            subject.call
          end
        end
      end

      context 'and the conversation is in an active campaign for the bot' do
        context 'for the same phone number as the message' do
          before do
            create(:campaign_contact,
                   state: :active,
                   phone_number: message.organization_phone_number,
                   campaign: campaign,
                   contact: conversation.contact)
          end

          context 'and the message is anything' do
            let!(:message) { create(:message, :to, conversation: conversation) }

            it 'calls Bot::Receiver' do
              expect(Bot::Receiver).to receive(:call).with(bot, message)

              subject.call
            end
          end
        end

        context 'different phone number than the message' do
          before do
            create(:campaign_contact,
                   state: :active,
                   campaign: campaign,
                   contact: conversation.contact)
          end

          context 'and the message is anything' do
            let!(:message) { create(:message, :to, conversation: conversation) }

            it 'does not call Bot::Receiver' do
              expect(Bot::Receiver).not_to receive(:call)

              subject.call
            end

            it 'calls ReadReceiptsCreator' do
              expect(ReadReceiptsCreator).to receive(:call)

              subject.call
            end
          end
        end
      end
    end
  end
end