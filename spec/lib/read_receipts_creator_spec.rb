require 'rails_helper'

RSpec.describe ReadReceiptsCreator do
  let(:team) { create(:team, :inbox) }
  let(:organization) { team.organization }
  let(:contact) { create(:contact, team: team) }
  let!(:message) { create(:message, sender: contact.person, conversation: contact.open_conversation) }

  subject { ReadReceiptsCreator.new(message, contact) }

  describe '#call' do
    let(:conversation) { contact.open_conversation }

    context 'and the read receipt does not exist' do
      it 'creates one' do
        expect {
          subject.call
        }.to change { conversation.read_receipts.count }.by(1)
      end

      context 'with two accounts on the team' do
        before do
          team.accounts << create(:account, organization: organization)
          team.accounts << create(:account, organization: organization)
        end

        it 'creates a ContactWaitingJob' do
          wait_until = 2.minutes.from_now
          allow(ReadReceiptsCreator).to receive(:wait_until).and_return(wait_until)

          expect {
            subject.call
          }.to have_enqueued_job(ContactWaitingJob).at(wait_until).exactly(:once)
        end
      end
    end

    context 'and a read receipt exists already' do
      before do
        subject.call
      end

      it 'does not create a read receipt' do
        expect {
          subject.call
        }.not_to change { ReadReceipt.count }
      end

      it 'does not creates a ContactWaitingJob' do
        expect {
          subject.call
        }.not_to have_enqueued_job(ContactWaitingJob)
      end
    end
  end
end
