require 'rails_helper'

RSpec.describe Bot::Response do
  let(:bot) { create(:bot) }
  let(:bot_campaign) { create(:bot_campaign, bot: bot) }
  let(:campaign) { bot_campaign.campaign }
  let(:message) { create(:message, :conversation_part) }
  let(:contact) { message.contact }
  let(:campaign_contact) { create(:campaign_contact, contact: contact, campaign: campaign) }

  subject { Bot::Response.new(bot, message, campaign_contact) }

  describe '#sender' do
    it 'is the bot person' do
      expect(subject.sender).to eq(bot.person)
    end
  end

  describe '#conversation' do
    it 'is the message conversation' do
      expect(subject.conversation).to eq(message.conversation)
    end
  end

  describe '#body' do
    context 'campaign contact does not have a question' do
      it 'greets the candidate' do
        expect(bot).to receive(:greet)

        subject.body
      end

      context 'calling body twice' do
        it 'only greets the candidate once' do
          expect(bot).to receive(:greet).exactly(:once) { 'greeting' }

          subject.body
          subject.body
        end
      end
    end

    context 'campaign contact does have a question' do
      let!(:question) { create(:choice_question, bot: bot) }

      before do
        campaign_contact.update(question: question)
      end

      it 'does not greet the candidate' do
        allow(question).to receive(:follow_up)
        expect(bot).not_to receive(:greet)

        subject.body
      end

      it 'follows up on the question' do
        expect(question).to receive(:follow_up)

        subject.body
      end

      context 'and the question is deleted' do
        before do
          question.destroy
        end

        it 'does not greet the candidate' do
          allow(question).to receive(:follow_up)
          expect(bot).not_to receive(:greet)

          subject.body
        end

        it 'follows up on the question' do
          expect(question).to receive(:follow_up)

          subject.body
        end
      end

      context 'calling body twice' do
        it 'follows up with the candidate once' do
          expect(question).to receive(:follow_up).exactly(:once) { 'follow up' }

          subject.body
          subject.body
        end
      end
    end
  end
end
