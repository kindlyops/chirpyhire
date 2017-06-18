class TeamInboxConversation < ApplicationRecord
  belongs_to :conversation
  belongs_to :team_inbox
end
