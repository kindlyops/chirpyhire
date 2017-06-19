require 'rails_helper'

RSpec.describe 'Conversations' do
  describe 'show' do
    let(:account) { create(:account, :team) }
    let(:conversation) { create(:conversation) }

    context 'signed in' do
      before do
        sign_in(account)
      end

      context 'a conversation scoped to an account inbox' do
        context 'and the account inbox is tied to the current account' do
          let(:old_inbox) { create(:inbox, team: nil, account_id: account.id) }
          before do
            sql = "INSERT INTO inbox_conversations VALUES (123, NULL, now(), now(), 0, now(), #{old_inbox.id}, #{conversation.id})"
            ActiveRecord::Base.connection.execute(sql)
          end

          context 'and the conversation is within a team inbox' do
            context 'and the account is on the team' do
              let(:team_inbox) { account.teams.first.inbox }

              before do
                account.teams.first.inbox.conversations << conversation
              end

              it 'redirects to the inbox conversation' do
                get inbox_conversation_path(old_inbox, conversation)

                expect(response).to redirect_to(inbox_conversation_path(team_inbox, conversation))
              end
            end

            context 'and the account is not on the team' do
              let(:team_inbox) { create(:team, :inbox, organization: account.organization).inbox }

              before do
                team_inbox.conversations << conversation
              end

              it 'redirects to the team inbox conversation' do
                get inbox_conversation_path(old_inbox, conversation)

                expect(response).to redirect_to(inbox_conversation_path(team_inbox, conversation))
              end
            end
          end

          context 'and the conversation is not within a team inbox' do
            it 'redirects to home page' do
              get inbox_conversation_path(old_inbox, conversation)

              expect(response).to redirect_to(root_path)
            end
          end
        end

        context 'and the account inbox is not tied to the current account' do
          let(:other_account) { create(:account) }
          let(:old_inbox) { create(:inbox, team: nil, account_id: other_account.id) }

          before do
            sql = "INSERT INTO inbox_conversations VALUES (123, NULL, now(), now(), 0, now(), #{old_inbox.id}, #{conversation.id})"
            ActiveRecord::Base.connection.execute(sql)
          end

          it 'redirects to home page' do
            get inbox_conversation_path(old_inbox, conversation)

            expect(response).to redirect_to(root_path)
          end
        end
      end
    end
  end
end
