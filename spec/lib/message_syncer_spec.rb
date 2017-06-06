require 'rails_helper'

RSpec.describe MessageSyncer do
  let(:team) { create(:team, :account) }
  let(:organization) { team.organization }
  let(:contact) { create(:contact, team: team) }
  let(:message_sid) { 'sid' }

  before do
    IceBreaker.call(contact)
  end

  describe 'receipt' do
    before do
      IceBreaker.call(contact)
    end

    context 'receipt requested' do
      subject { MessageSyncer.new(contact, message_sid, receipt: true) }

      it 'calls ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).to receive(:call)

        subject.call
      end
    end

    context 'receipt not requested' do
      subject { MessageSyncer.new(contact, message_sid) }

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.call
      end
    end
  end

  describe 'conversations' do
    subject { MessageSyncer.new(contact, message_sid) }

    context 'existing conversation' do
      context 'open' do
        it 'does not create a new conversation' do
          expect {
            subject.call
          }.not_to change { Conversation.count }
        end

        it 'ties the message to the existing conversation' do
          expect {
            subject.call
          }.to change { contact.open_conversation.reload.messages.count }.by(1)
        end
      end

      context 'closed' do
        before do
          contact.conversations.each { |c| c.update(state: 'Closed') }
        end

        it 'creates a new open conversation' do
          expect {
            subject.call
          }.to change { Conversation.opened.count }.by(1)
        end

        it 'ties the message to the new open conversation' do
          subject.call
          expect(Conversation.opened.last.messages.count).to eq(1)
        end
      end
    end
  end
end
