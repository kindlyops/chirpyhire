class ManualMessageReply < ApplicationRecord
  belongs_to :message
  belongs_to :manual_message
end
