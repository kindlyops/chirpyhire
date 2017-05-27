require 'rails_helper'

RSpec.describe GlacierBreaker do
  let(:account) { create(:account, :inbox, :team) }
  let(:organization) { account.organization }

  subject { GlacierBreaker.new(account) }

  describe '#call' do
    context 'with multiple contacts on the organization' do
      let!(:contacts) { create_list(:contact, 3, team: account.teams.first) }
      let(:count) { organization.contacts.count }

      it 'creates a conversation for each contact on the organization' do
        expect {
          subject.call
        }.to change { organization.inbox_conversations.count }.by(count)
      end

      it 'ties the conversations to inboxes' do
        subject.call
        expect(organization.inbox_conversations.map(&:inbox).all?(&:present?)).to eq(true)
      end

      context 'with existing conversations' do
        before do
          create(:inbox_conversation, contact: contacts.first, inbox: account.inbox)
        end

        it 'creates a conversation for just contacts without a conversation' do
          expect {
            subject.call
          }.to change { organization.inbox_conversations.count }.by(count - 1)
        end
      end
    end

    context 'with contacts on other organizations' do
      let!(:contacts) { create_list(:contact, 3) }
      let(:count) { organization.contacts.count }

      it 'only creates conversations for contacts on the organization' do
        expect {
          subject.call
        }.to change { organization.inbox_conversations.count }.by(count)
      end
    end
  end
end
