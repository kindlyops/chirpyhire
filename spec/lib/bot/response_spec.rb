require 'rails_helper'

RSpec.describe Bot::Response do
  let(:bot) { create(:bot) }
  let(:goal) { bot.goals.first }
  let(:greeting) { bot.greeting }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:campaign_contact) { create(:campaign_contact, campaign: campaign) }

  let(:conversation) { create(:conversation, contact: campaign_contact.contact) }
  let!(:message) { create(:message, conversation: conversation) }

  subject { Bot::Response.new(bot, message, campaign_contact) }

  describe 'pending campaign conversation' do
    it 'does changes the campaign_contact state' do
      allow(subject).to receive(:reply)
      expect {
        subject.call
      }.to change { campaign_contact.reload.state }.from('pending').to('active')
    end

    it 'does send a message' do
      expect(subject).to receive(:reply)

      subject.call
    end
  end

  describe 'active campaign conversation' do
    before do
      campaign_contact.update(state: :active)
    end
  end

  describe 'exited campaign conversation' do
    let(:campaign_contact) { create(:campaign_contact, state: :exited) }

    it 'does not change the campaign_contact state' do
      expect {
        subject.call
      }.not_to change { campaign_contact.reload.state }
    end

    it 'does not send a message' do
      expect(subject).not_to receive(:reply)

      subject.call
    end
  end
end
