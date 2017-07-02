require 'rails_helper'

RSpec.describe Bot::Responder do
  let(:bot) { create(:bot) }
  let(:goal) { bot.goals.first }
  let(:greeting) { bot.greeting }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:campaign_conversation) { create(:campaign_conversation, campaign: campaign) }

  let(:conversation) { campaign_conversation.conversation }
  let!(:message) { create(:message, conversation: conversation) }

  subject { Bot::Responder.new(bot, message, campaign_conversation) }

  describe 'pending campaign conversation' do
    it 'does changes the campaign_conversation state' do
      allow(subject).to receive(:reply)
      expect {
        subject.call
      }.to change { campaign_conversation.reload.state }.from("pending").to("active")
    end

    it 'does send a message' do
      expect(subject).to receive(:reply)

      subject.call
    end
  end

  describe 'active campaign conversation' do
    before do
      campaign_conversation.update(state: :active)
    end
  end

  describe 'exited campaign conversation' do
    let(:campaign_conversation) { create(:campaign_conversation, state: :exited) }

    it 'does not change the campaign_conversation state' do
      expect {
        subject.call
      }.not_to change { campaign_conversation.reload.state }
    end

    it 'does not send a message' do
      expect(subject).not_to receive(:reply)

      subject.call
    end
  end
end
