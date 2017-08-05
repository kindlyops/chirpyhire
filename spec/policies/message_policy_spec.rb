require 'rails_helper'

RSpec.describe MessagePolicy do
  describe 'policies' do
    let(:account) { create(:account, :team) }
    let(:organization) { account.organization }
    subject { described_class.new(account, message) }

    context 'contact on same team' do
      context 'contact not actively subscribed' do
        let(:contact) { create(:contact, subscribed: false, organization: account.organization) }
        let!(:message) { build(:message, :conversation_part, organization: organization, recipient: contact.person) }

        it { is_expected.to forbid_action(:create) }
      end

      context 'contact is actively subscribed' do
        let(:contact) { create(:contact, subscribed: true, organization: account.organization) }
        let!(:message) { build(:message, :conversation_part, organization: account.organization, recipient: contact.person) }

        it { is_expected.to permit_action(:create) }

        context 'and the subscription is canceled' do
          before do
            organization.subscription.update(status: :canceled)
          end
          it { is_expected.to forbid_action(:create) }
        end
      end
    end
  end

  describe 'scope' do
    subject { MessagePolicy::Scope.new(account, Message.all) }

    context 'organizations' do
      let(:organization) { create(:organization, :team, :account) }
      let(:phone_number) { organization.phone_numbers.first }
      let(:account) { organization.accounts.first }
      let(:other_organization) { create(:organization) }
      let(:contact) { create(:contact, organization: other_organization) }
      let(:conversation) { create(:conversation, contact: contact) }
      let!(:message) { create(:message, organization: other_organization, conversation: conversation, sender: contact.person) }

      context 'account is on a different organization than the message contact' do
        it 'does not include the message' do
          expect(subject.resolve).not_to include(message)
        end
      end

      context 'account is on same organization as the message contact' do
        let(:organization) { create(:organization, :account) }
        let(:account) { organization.accounts.first }
        let(:contact) { create(:contact, organization: organization) }
        let(:conversation) { create(:conversation, contact: contact) }
        let!(:message) { create(:message, organization: organization, conversation: conversation, sender: contact.person) }

        it 'does include the message' do
          expect(subject.resolve).to include(message)
        end
      end
    end
  end
end
