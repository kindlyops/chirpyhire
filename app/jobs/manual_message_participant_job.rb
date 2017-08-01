class ManualMessageParticipantJob < ApplicationJob
  def perform(participant)
    ManualMessageParticipant::Runner.call(participant)
  end
end
