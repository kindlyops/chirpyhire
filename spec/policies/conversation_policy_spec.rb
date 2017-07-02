require 'rails_helper'

RSpec.describe ConversationPolicy do
  describe 'scope' do
    subject { ConversationPolicy::Scope.new(account, Conversation.all) }

    context 'organizations' do
      let(:organization) { create(:organization, :account) }
      let(:account) { organization.accounts.first }
      let(:other_organization) { create(:organization, :team) }
      let(:contact) { create(:contact, organization: other_organization) }
      let(:other_team) { other_organization.teams.first }
      let!(:conversation) { create(:conversation, inbox: other_team.inbox, contact: contact) }

      context 'account is on a different organization than the conversation contact' do
        it 'does not include the conversation' do
          expect(subject.resolve).not_to include(conversation)
        end
      end

      context 'account is on same organization as the conversation contact' do
        let(:organization) { create(:organization, :account, :team) }
        let(:account) { organization.accounts.first }
        let(:contact) { create(:contact, organization: organization) }
        let(:team) { organization.teams.first }
        let!(:conversation) { create(:conversation, inbox: team.inbox, contact: contact) }

        it 'does include the conversation' do
          expect(subject.resolve).to include(conversation)
        end
      end
    end
  end
end
