class ManualMessageParticipant < ApplicationRecord
  belongs_to :contact
  belongs_to :manual_message
  belongs_to :message, optional: true
  belongs_to :reply, optional: true, class_name: 'Message'
end
