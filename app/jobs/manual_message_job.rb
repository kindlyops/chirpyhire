class ManualMessageJob < ApplicationJob
  def perform(manual_message)
    manual_message.update(started_sending_at: DateTime.current)
    manual_message.unreached_participants.find_each do |participant|
      ManualMessageParticipantJob.perform_later(participant)
    end
  end
end
