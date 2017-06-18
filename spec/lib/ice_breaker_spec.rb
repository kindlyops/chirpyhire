require 'rails_helper'

RSpec.describe IceBreaker do
  let(:team) { create(:team) }
  let(:contact) { create(:contact, team: team) }
  let(:organization) { contact.organization }

  subject { IceBreaker.new(contact) }

  describe '#call' do
    context 'with multiple accounts on the organization' do
      let!(:accounts) { create_list(:account, 3, :inbox, organization: contact.organization) }
      let(:count) { organization.accounts.count }

      context 'and none are on the contact team' do
        it 'does not create inbox conversations for the accounts' do
          expect {
            subject.call
          }.not_to change { InboxConversation.count }
        end

        it 'creates a team inbox conversation for the contact team inbox' do
          expect {
            subject.call
          }.to change { TeamInboxConversation.count }.by(1)
          expect(TeamInboxConversation.last.team_inbox).to eq(contact.team.inbox)
        end
      end

      context 'and all are on the contact team' do
        before do
          contact.team.accounts << accounts
        end

        it 'creates an inbox conversation for each account on the organization' do
          expect {
            subject.call
          }.to change { InboxConversation.count }.by(count)
        end

        context 'with existing conversation' do
          context 'that is open' do
            let(:open_conversation) { contact.conversations.create! }

            context 'that is tied to an account' do
              before do
                create(:inbox_conversation, inbox: accounts.first.inbox, conversation: open_conversation)
              end

              it 'creates an inbox conversations for accounts without a conversation tied to the open conversation' do
                expect {
                  subject.call
                }.to change { InboxConversation.count }.by(count - 1)
                expect(InboxConversation.last.conversation).to eq(open_conversation)
              end

              it 'creates an inbox conversation for the contact team' do
                subject.call
                expect(contact.existing_open_conversation.team_inboxes).to include(contact.team.inbox)
              end
            end
          end
        end
      end
    end

    context 'with accounts on other organizations' do
      let!(:accounts) { create_list(:account, 3) }

      it 'does not create inbox conversations' do
        expect {
          subject.call
        }.not_to change { InboxConversation.count }
      end
    end
  end
end
