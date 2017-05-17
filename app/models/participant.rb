class Participant < ApplicationRecord
  belongs_to :account
  belongs_to :conversation
end
