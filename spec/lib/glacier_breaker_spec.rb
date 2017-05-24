require 'rails_helper'

RSpec.describe GlacierBreaker do
  let(:account) { create(:account, :team) }
  let(:organization) { account.organization }

  subject { GlacierBreaker.new(account) }

  describe '#call' do
    context 'with multiple contacts on the organization' do
      let!(:contacts) { create_list(:contact, 3, team: account.teams.first) }
      let(:count) { organization.contacts.count }

      it 'creates a conversation for each contact on the organization' do
        expect {
          subject.call
        }.to change { organization.conversations.count }.by(count)
      end

      context 'with existing conversations' do
        before do
          create(:conversation, contact: contacts.first, account: account)
        end

        it 'creates a conversation for just contacts without a conversation' do
          expect {
            subject.call
          }.to change { organization.conversations.count }.by(count - 1)
        end
      end
    end

    context 'with contacts on other organizations' do
      let!(:contacts) { create_list(:contact, 3) }
      let(:count) { organization.contacts.count }

      it 'only creates conversations for contacts on the organization' do
        expect {
          subject.call
        }.to change { organization.conversations.count }.by(count)
      end
    end
  end
end
