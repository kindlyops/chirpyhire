require 'rails_helper'

RSpec.describe Courier do
  describe 'call' do
    subject { Courier.new(contact, message) }
    let!(:contact) { create(:contact) }

    context 'with bots' do
      context 'multiple on call for an inbox' do
        let(:bot_a) { create(:bot, keyword: 'start', organization: contact.organization) }
        let(:greeting_a) { bot_a.greeting }
        let(:bot_b) { create(:bot, keyword: 'care', organization: contact.organization) }
        let(:inbox) { create(:team, :inbox, organization: contact.organization).inbox }

        let(:on_call_campaign_a) { create(:campaign, name: "On Call: #{bot_a.name}") }

        before do
          inbox.bots << bot_a
          bot_a.campaigns << on_call_campaign_a
          inbox.bots << bot_b
        end

        context 'contact is not in a bot campaign' do
          context 'message triggers bot to start' do
            let(:conversation) { contact.open_conversation }
            let(:message) { create(:message, sender: contact.person, conversation: conversation, body: 'start') }

            it 'adds the contact to the on call campaign' do
              expect {
                subject.call
              }.to change { on_call_campaign_a.contacts.count }.by(1)
            end

            context 'with bot questions' do
              let(:question) { create(:question, bot: bot_a) }
              let(:message_body) { greeting_a.body << "\n\n" << question.body }
              xit 'sends a message with the bot greeting and the first question' do
                expect(bot_a).to receive(:send_message).with(message_body)

                subject.call
              end
            end

            context 'without bot questions' do
              it 'sends a message with the bot greeting and the goal message' do
              end

              context 'with goal tags' do
                it 'adds the goal tags to the contact' do
                end
              end
            end
          end

          context 'message would not trigger bot to start' do
          end
        end

        context 'contact is already in a bot campaign' do
          context 'message triggers bot to start' do
          end

          context 'message would not trigger bot to start' do
            context 'message is a valid response to current question' do
            end

            context 'message is not a valid response to current question' do
            end
          end
        end
      end

      context 'one bot on call for the inbox' do
        context 'contact is not in a bot campaign' do
          context 'message triggers bot to start' do
          end

          context 'message would not trigger bot to start' do
          end
        end

        context 'contact is already in the bot campaign' do
          context 'message triggers bot to start' do
          end

          context 'message would not trigger bot to start' do
            context 'message is a valid response to current question' do
            end

            context 'message is not a valid response to current question' do
            end
          end
        end
      end
    end

    context 'without bots' do
    end
  end
end
