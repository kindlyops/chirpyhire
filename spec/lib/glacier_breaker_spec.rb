require 'rails_helper'

RSpec.describe GlacierBreaker do
  let(:team) { create(:team, :account) }
  let(:account) { team.accounts.first }

  subject { GlacierBreaker.new(account) }

  describe '#call' do
    context 'with multiple contacts on the team' do
      let!(:contacts) { create_list(:contact, 3, team: team) }
      let(:count) { team.contacts.count }

      it 'creates a conversation for each contact on the team' do
        expect {
          subject.call
        }.to change { team.conversations.count }.by(count)
      end

      context 'with existing conversations' do
        before do
          create(:conversation, contact: contacts.first, account: account)
        end

        it 'creates a conversation for just contacts without a conversation' do
          expect {
            subject.call
          }.to change { team.conversations.count }.by(count - 1)
        end
      end
    end

    context 'with contacts on other teams' do
      let!(:contacts) { create_list(:contact, 3) }
      let(:count) { team.contacts.count }

      it 'only creates conversations for contacts on the team' do
        expect {
          subject.call
        }.to change { team.conversations.count }.by(count)
      end
    end
  end
end
