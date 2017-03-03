class Broadcaster::CandidacyProgress
  def initialize(candidacy)
    @candidacy = candidacy
  end

  def broadcast
    CandidacyProgressesChannel.broadcast_to(candidacy, candidacy.progress.round)
  end

  private

  attr_reader :candidacy
end
