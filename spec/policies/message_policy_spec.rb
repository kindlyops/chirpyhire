require 'rails_helper'

RSpec.describe MessagePolicy do
  describe 'policies' do
    let(:account) { create(:account, :team) }
    subject { described_class.new(account, message) }

    context 'contact on same team' do
      context 'contact not actively subscribed' do
        let(:contact) { create(:contact, subscribed: false, team: account.teams.first) }
        let!(:message) { build(:message, recipient: contact.person) }

        it { is_expected.to forbid_action(:create) }
      end

      context 'contact is actively subscribed' do
        let(:contact) { create(:contact, subscribed: true, team: account.teams.first) }
        let!(:message) { build(:message, recipient: contact.person) }

        it { is_expected.to permit_action(:create) }
      end
    end

    context 'contact on different team' do
      let(:contact) { create(:contact, subscribed: true) }
      let!(:message) { build(:message, recipient: contact.person) }

      it { is_expected.to forbid_action(:create) }
    end
  end

  describe 'scope' do
    subject { MessagePolicy::Scope.new(account, Message.all) }

    context 'teams' do
      let(:team) { create(:team, :account) }
      let(:account) { team.accounts.first }
      let(:other_team) { create(:team, organization: team.organization) }
      let(:contact) { create(:contact, team: other_team) }
      let!(:message) { create(:message, conversation: contact.open_conversation, sender: contact.person) }

      before do
        IceBreaker.call(contact)
      end

      context 'account is on a different team than the message contact' do
        it 'does include the message' do
          expect(subject.resolve).to include(message)
        end
      end

      context 'account is on same team as the message contact' do
        let(:team) { create(:team, :account) }
        let(:account) { team.accounts.first }
        let(:contact) { create(:contact, team: team) }
        let!(:message) { create(:message, conversation: contact.open_conversation, sender: contact.person) }

        it 'does include the message' do
          expect(subject.resolve).to include(message)
        end
      end
    end
  end
end
