require 'rails_helper'

RSpec.describe ConversationPolicy do
  describe 'scope' do
    subject { ConversationPolicy::Scope.new(account, Conversation.all) }

    context 'teams' do
      let(:team) { create(:team, :inbox, :account) }
      let(:account) { team.accounts.first }
      let(:other_team) { create(:team, :inbox, organization: team.organization) }
      let(:contact) { create(:contact, team: other_team) }
      let!(:conversation) { create(:conversation, inbox: other_team.inbox, contact: contact) }

      context 'account is on a different team than the conversation contact' do
        it 'does include the conversation' do
          expect(subject.resolve).to include(conversation)
        end
      end

      context 'account is on same team as the conversation contact' do
        let(:team) { create(:team, :inbox, :account) }
        let(:account) { team.accounts.first }
        let(:contact) { create(:contact, team: team) }
        let!(:conversation) { create(:conversation, inbox: team.inbox, contact: contact) }

        it 'does include the conversation' do
          expect(subject.resolve).to include(conversation)
        end
      end
    end
  end
end
