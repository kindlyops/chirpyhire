require 'rails_helper'

RSpec.describe InboxDeliveryAgent do
  describe 'call' do
    subject { InboxDeliveryAgent.new(inbox, message) }

    context 'with a bot tied to the inbox' do
      let(:organization) { create(:organization, :team_with_phone_number_and_recruiting_ad_and_inbox) }
      let(:bot) { organization.bots.first }
      let!(:inbox) { organization.teams.first.inbox }
      let(:bot_campaign) { inbox.bot_campaigns.first }
      let(:campaign) { bot_campaign.campaign }
      let(:contact) { create(:contact, organization: organization) }
      let(:conversation) { create(:conversation, contact: contact, inbox: inbox) }

      context 'and the conversation is not in an active campaign for the bot' do
        context 'and the message would trigger the bot (START)' do
          let!(:message) { create(:message, body: 'start', organization: organization, conversation: conversation) }

          it 'calls Bot::Receiver' do
            expect(Bot::Receiver).to receive(:call).with(bot, message)

            subject.call
          end
        end

        context 'and the message would not trigger the bot' do
          let!(:message) { create(:message, body: 'I am interested in work', organization: organization, conversation: conversation) }

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.call
          end
        end
      end

      context 'and the conversation is in an exited campaign for the bot' do
        before do
          create(:campaign_contact, state: :exited, campaign: campaign, contact: contact)
        end

        context 'and the message would trigger the bot' do
          let!(:message) {
            create(:message, :conversation_part,
                   to: organization.phone_numbers.first.phone_number,
                   body: 'start', organization: organization,
                   conversation: conversation)
          }

          it 'does not calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).not_to receive(:call)

            subject.call
          end

          it 'does call Bot::Receiver' do
            expect(Bot::Receiver).to receive(:call)

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
                   contact: contact)
          end

          context 'and the message is anything' do
            let!(:message) { create(:message, :to, organization: organization, conversation: conversation) }

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
                   contact: contact)
          end

          context 'and the message is anything' do
            let!(:message) { create(:message, :to, organization: organization, conversation: conversation) }

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
