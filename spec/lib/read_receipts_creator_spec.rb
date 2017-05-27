require 'rails_helper'

RSpec.describe ReadReceiptsCreator do
  let(:team) { create(:team) }
  let(:organization) { team.organization }
  let(:contact) { create(:contact, team: team) }
  let!(:message) { create(:message, sender: contact.person, organization: organization) }

  subject { ReadReceiptsCreator.new(message, contact) }

  describe '#call' do
    context 'with multiple conversations on the organization' do
      let!(:accounts) { create_list(:account, 3, :inbox, organization: organization) }
      let!(:inboxes) { accounts.map(&:inbox) }
      let!(:conversations) { inboxes.map { |i| i.inbox_conversations.create(contact: contact) } }

      context 'and the read receipts do not exist' do
        context 'and the contact and accounts are on the same team' do
          before do
            team.accounts << accounts
            conversations.map(&:contact).each { |c| c.update(team: team) }
          end

          let(:count) { team.inbox_conversations.count }

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

        context 'and the contact and accounts are not on the same team' do
          it 'does not create a read receipt for each conversation in the organization' do
            expect {
              subject.call
            }.not_to change { ReadReceipt.count }
          end

          it 'creates a ContactWaitingJob for each conversation in the organization' do
            wait_until = 2.minutes.from_now
            allow(ReadReceiptsCreator).to receive(:wait_until).and_return(wait_until)

            expect {
              subject.call
            }.not_to have_enqueued_job(ContactWaitingJob).at(wait_until)
          end
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
      let!(:conversations) { create_list(:inbox_conversation, 3) }
      let(:count) { team.inbox_conversations.count }

      it 'only creates read receipts for the team conversations' do
        expect {
          subject.call
        }.to change { ReadReceipt.count }.by(count)
      end
    end
  end
end
