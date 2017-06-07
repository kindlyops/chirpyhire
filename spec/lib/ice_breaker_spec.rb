require 'rails_helper'

RSpec.describe IceBreaker do
  let(:contact) { create(:contact) }
  let(:organization) { contact.organization }

  subject { IceBreaker.new(contact) }

  describe '#call' do
    context 'with multiple accounts on the organization' do
      let!(:accounts) { create_list(:account, 3, :inbox, organization: contact.organization) }
      let(:count) { organization.accounts.count }

      it 'creates an inbox conversation for each account on the organization' do
        expect {
          subject.call
        }.to change { organization.reload.inbox_conversations.count }.by(count)
      end

      context 'with existing conversations' do
        before do
          create(:inbox_conversation, inbox: accounts.first.inbox, conversation: contact.conversations.create!)
        end

        it 'creates an inbox conversation for just accounts without a conversation' do
          expect {
            subject.call
          }.to change { organization.reload.inbox_conversations.count }.by(count - 1)
        end
      end
    end

    context 'with accounts on other organizations' do
      let!(:accounts) { create_list(:account, 3) }
      let(:count) { organization.accounts.count }

      it 'only creates inbox conversations for accounts on the organization' do
        expect {
          subject.call
        }.to change { organization.reload.inbox_conversations.count }.by(count)
      end
    end
  end
end
