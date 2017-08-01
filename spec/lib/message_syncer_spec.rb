require 'rails_helper'

RSpec.describe MessageSyncer do
  let(:organization) { create(:organization, :account) }
  let(:phone_number) { create(:phone_number, organization: organization, phone_number: ENV.fetch('DEMO_ORGANIZATION_PHONE')) }
  let(:team) { create(:team, organization: organization) }
  let!(:assignment_rule) { create(:assignment_rule, organization: organization, inbox: team.create_inbox, phone_number: phone_number) }
  let(:contact) { create(:contact, organization: organization) }
  let(:message_sid) { 'sid' }

  describe 'call' do
    subject { MessageSyncer.new(contact, message_sid) }

    it "sets 'from' on the message" do
      subject.call

      expect(Message.last.from).to be_present
    end

    it "sets 'to' on the message" do
      subject.call

      expect(Message.last.to).to be_present
    end
  end

  describe 'receipt' do
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

    context 'without an existing conversation' do
      it 'creates an open conversation' do
        expect {
          subject.call
        }.to change { Conversation.opened.count }.by(1)
      end
    end

    context 'existing conversation' do
      let!(:conversation) { IceBreaker.call(contact, phone_number) }

      context 'open' do
        it 'does not create a new conversation' do
          expect {
            subject.call
          }.not_to change { Conversation.count }
        end

        it 'ties the message to the existing conversation' do
          expect {
            subject.call
          }.to change { conversation.reload.messages.count }.by(1)
        end

        context 'with an existing message' do
          let(:message) { create(:message, conversation: conversation) }

          context 'that has a manual message participant' do
            let!(:participant) { create(:manual_message_participant, message: message) }

            it 'sets the new message as the reply on the manual message participant' do
              expect {
                subject.call
              }.to change { participant.reload.reply }.from(nil)
              expect(participant.reply).to eq(Message.last)
            end
          end
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
