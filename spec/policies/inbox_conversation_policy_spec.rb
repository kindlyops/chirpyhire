require 'rails_helper'

RSpec.describe InboxConversationPolicy do
  describe 'scope' do
    subject { InboxConversationPolicy::Scope.new(account, InboxConversation.all) }

    context 'teams' do
      let(:team) { create(:team, :account) }
      let(:account) { team.accounts.first }
      let(:other_team) { create(:team, organization: team.organization) }
      let(:contact) { create(:contact, team: other_team) }
      let!(:conversation) { create(:inbox_conversation, inbox: account.inbox, contact: contact) }

      context 'account is on a different team than the conversation contact' do
        it 'does not include the conversation' do
          expect(subject.resolve).not_to include(conversation)
        end
      end

      context 'account is on same team as the conversation contact' do
        let(:team) { create(:team, :account) }
        let(:account) { team.accounts.first }
        let(:contact) { create(:contact, team: team) }
        let!(:conversation) { create(:inbox_conversation, inbox: account.inbox, contact: contact) }

        it 'does include the conversation' do
          expect(subject.resolve).to include(conversation)
        end
      end
    end
  end
end