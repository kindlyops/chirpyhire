require 'rails_helper'

RSpec.describe Bot::Receiver do
  let(:bot_campaign) { create(:bot_campaign) }
  let!(:inbox) { bot_campaign.inbox }
  let!(:campaign) { bot_campaign.campaign }
  let!(:bot) { bot_campaign.bot }

  subject { Bot::Receiver.new(bot, message) }

  describe 'call' do
    context 'conversation is not in the bot campaign' do
      let(:conversation) { create(:conversation, inbox: inbox) }
      let(:contact) { conversation.contact }
      let!(:message) { create(:message, :to, conversation: conversation) }

      it 'creates a pending campaign contact' do
        allow(subject).to receive(:reply)
        expect {
          subject.call
        }.to change { contact.reload.campaign_contacts.pending.count }.by(1)
      end

      it 'updates the message to be tied to the campaign' do
        allow(subject).to receive(:reply)
        expect {
          subject.call
        }.to change { message.reload.campaign }.from(nil).to(campaign)
      end

      it 'ties the new campaign contact to the bot campaign' do
        allow(subject).to receive(:reply)
        subject.call

        expect(CampaignContact.last.campaign).to eq(campaign)
      end

      it 'replies' do
        expect(subject).to receive(:reply)

        subject.call
      end
    end

    context 'conversation is in the bot campaign' do
      let(:conversation) { create(:conversation, inbox: inbox) }
      let(:contact) { conversation.contact }
      let!(:campaign_contact) { create(:campaign_contact, contact: contact, campaign: campaign) }
      let!(:message) { create(:message, :to, conversation: conversation) }

      context 'exited' do
        before do
          campaign_contact.update(state: :exited)
        end

        it 'does not create a campaign contact' do
          expect {
            subject.call
          }.not_to change { contact.reload.campaigns.count }
        end

        it 'updates the message to be tied to the campaign' do
          expect {
            subject.call
          }.to change { message.reload.campaign }.from(nil).to(campaign)
        end

        it 'does not reply' do
          expect(subject).not_to receive(:reply)

          subject.call
        end
      end

      context 'active' do
        it 'does not create a campaign contact' do
          allow(subject).to receive(:reply)
          expect {
            subject.call
          }.not_to change { contact.reload.campaigns.count }
        end

        it 'updates the message to be tied to the campaign' do
          allow(subject).to receive(:reply)
          expect {
            subject.call
          }.to change { message.reload.campaign }.from(nil).to(campaign)
        end

        it 'replies' do
          expect(subject).to receive(:reply)

          subject.call
        end
      end
    end
  end
end
