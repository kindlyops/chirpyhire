require 'rails_helper'

RSpec.describe ReadReceiptsCreator do
  let(:organization) { create(:organization) }
  let(:contact) { create(:contact, organization: organization) }
  let!(:message) { create(:message, sender: contact.person, organization: organization) }

  subject { ReadReceiptsCreator.new(message, organization) }

  describe '#call' do
    context 'with multiple conversations on the organization' do
      let!(:accounts) { create_list(:account, 3, organization: organization) }
      let!(:conversations) { accounts.map { |a| a.conversations.create(contact: contact) } }
      let(:count) { organization.conversations.count }

      context 'and the read receipts do not exist' do
        it 'creates a read receipt for each conversation in the organization' do
          expect {
            subject.call
          }.to change { ReadReceipt.count }.by(count)
        end

        it 'creates a ContactWaitingJob for each conversation in the organization' do
          wait_until = 2.minutes.from_now
          allow(ReadReceiptsCreator).to receive(:wait_until).and_return(wait_until)

          expect {
            subject.call
          }.to have_enqueued_job(ContactWaitingJob).at(wait_until).exactly(count).times
        end
      end

      context 'and the read receipts exist already' do
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

    context 'with conversations on other organizations' do
      let!(:conversations) { create_list(:conversation, 3) }
      let(:count) { organization.conversations.count }

      it 'only creates read receipts for the organization conversations' do
        expect {
          subject.call
        }.to change { ReadReceipt.count }.by(count)
      end
    end
  end
end
