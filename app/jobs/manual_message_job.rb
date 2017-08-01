class ManualMessageJob < ApplicationJob
  def perform(manual_message)
    manual_message.unreached_participants.find_each do |participant|
      ManualMessageParticipantJob.perform_later(participant)
    end
  end
end
