class OnCall < ApplicationRecord
  belongs_to :inbox
  belongs_to :bot
end
