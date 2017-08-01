class ManualMessageParticipant::Runner
  def self.call(participant)
    new(participant).call
  end

  def initialize(participant)
    @participant = participant
  end

  attr_reader :participant

  def call
    # send message to participant and log message
  end
end
