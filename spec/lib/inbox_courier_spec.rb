require 'rails_helper'

RSpec.describe InboxCourier do
  describe 'call' do
    subject { InboxCourier.new(contact, message) }
    let!(:contact) { create(:contact) }
    let(:conversation) { contact.open_conversation }

    context 'with bots' do
      context 'bot campaign for inbox' do
        let(:bot) { create(:bot, organization: contact.organization) }
        let(:greeting) { bot.greeting }
        let(:goal) { bot.goals.first }
        let(:bot_campaign) { create(:bot_campaign, bot: bot, inbox: contact.team.inbox) }
        let(:campaign) { bot_campaign.campaign }

        context 'contact is not in the bot campaign' do
          context 'message triggers bot to start' do
            let(:message) { create(:message, sender: contact.person, body: 'start', conversation: conversation) }

            it 'adds the contact to the campaign' do
              expect {
                subject.call
              }.to change { campaign.reload.contacts.count }.by(1)
            end

            it 'sets the campaign contact status to in_progress' do
              subject.call

              campaign_contact = campaign.campaign_contacts.find_by(contact: contact)
              expect(campaign_contact.in_progress?).to eq(true)
            end

            it 'sends a message' do
              expect {
                subject.call
              }.to change { conversation.reload.messages.count }.by(1)
            end

            it 'includes the greeting' do
              subject.call

              expect(Message.last.body).to include(greeting.body)
            end

            context 'with questions' do
              let!(:question) { create(:question, bot: bot, rank: 1) }

              it 'includes the first question' do
                subject.call

                expect(Message.last.body).to include(question.body)
              end
            end

            context 'without questions' do
              it 'includes the goal' do
                subject.call

                expect(Message.last.body).to include(goal.body)
              end

              context 'and the goal has tags' do
                let(:tags) { create_list(:tag, 2, organization: organization) }
                before do
                  goal.tags << tags
                end

                it 'applies the tags to the contact' do
                  expect {
                    subject.call
                  }.to change { contact.tags.count }.by(2)
                end
              end
            end
          end

          context 'message would not trigger bot to start' do
            let(:message) { create(:message, sender: contact.person, body: '123', conversation: conversation) }

            it 'does not add the contact to the campaign' do
              expect {
                subject.call
              }.not_to change { campaign.reload.contacts.count }
            end

            it 'creates a read receipt' do
              expect {
                subject.call
              }.to change { ReadReceipt.count }.by(1)
            end

            it 'creates a ContactWaitingJob' do
              expect {
                subject.call
              }.to have_enqueued_job(ContactWaitingJob)
            end

            it 'does not send a message' do
              expect {
                subject.call
              }.not_to change { conversation.reload.messages.count }.by(1)
            end
          end
        end

        context 'contact is already in the bot campaign' do
          let!(:campaign_contact) { create(:campaign_contact, campaign: campaign, contact: contact, state: :in_progress) }

          context 'message triggers bot to start' do
            let(:message) { create(:message, sender: contact.person, body: 'start', conversation: conversation) }

            it 'does not add the contact to the campaign' do
              expect {
                subject.call
              }.not_to change { campaign.reload.contacts.count }
            end

            it 'creates a read receipt' do
              expect {
                subject.call
              }.to change { ReadReceipt.count }.by(1)
            end

            it 'creates a ContactWaitingJob' do
              expect {
                subject.call
              }.to have_enqueued_job(ContactWaitingJob)
            end

            it 'does not send a message' do
              expect {
                subject.call
              }.not_to change { conversation.reload.messages.count }.by(1)
            end
          end

          context 'message would not trigger bot to start' do
            context 'message is a valid response to current question' do
              let(:message) { create(:message, sender: contact.person, body: 'A', conversation: conversation) }

              it 'sends a message' do
                expect {
                  subject.call
                }.to change { conversation.reload.messages.count }.by(1)
              end

              context 'with another question' do
                let!(:next_question) { create(:question, bot: bot, rank: 2) }

                it 'includes the next question' do
                  subject.call

                  expect(Message.last.body).to include(next_question.body)
                end
              end

              context 'without another question' do
                it 'includes the goal' do
                  subject.call

                  expect(Message.last.body).to include(goal.body)
                end

                context 'and the goal has tags' do
                  let(:tags) { create_list(:tag, 2, organization: organization) }
                  before do
                    goal.tags << tags
                  end

                  it 'applies the tags to the contact' do
                    expect {
                      subject.call
                    }.to change { contact.tags.count }.by(2)
                  end
                end
              end
            end

            context 'message is not a valid response to current question' do
              let(:message) { create(:message, sender: contact.person, body: '123', conversation: conversation) }

              it 'does not add the contact to the campaign' do
                expect {
                  subject.call
                }.not_to change { campaign.reload.contacts.count }
              end

              it 'creates a read receipt' do
                expect {
                  subject.call
                }.to change { ReadReceipt.count }.by(1)
              end

              it 'creates a ContactWaitingJob' do
                expect {
                  subject.call
                }.to have_enqueued_job(ContactWaitingJob)
              end

              it 'does not send a message' do
                expect {
                  subject.call
                }.not_to change { conversation.reload.messages.count }.by(1)
              end
            end
          end
        end
      end
    end

    context 'without bots' do
      let(:message) { create(:message, sender: contact.person, body: 'start', conversation: conversation) }

      it 'does not add the contact to a campaign' do
        expect {
          subject.call
        }.not_to change { CampaignContact.count }
      end

      it 'creates a read receipt' do
        expect {
          subject.call
        }.to change { ReadReceipt.count }.by(1)
      end

      it 'creates a ContactWaitingJob' do
        expect {
          subject.call
        }.to have_enqueued_job(ContactWaitingJob)
      end

      it 'does not send a message' do
        expect {
          subject.call
        }.not_to change { conversation.reload.messages.count }.by(1)
      end
    end
  end
end
