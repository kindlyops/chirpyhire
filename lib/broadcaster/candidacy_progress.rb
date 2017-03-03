class Broadcaster::CandidacyProgress
  def initialize(candidacy)
    @candidacy = candidacy
  end

  def broadcast
    CandidacyProgressesChannel.broadcast_to(candidacy, render_progress)
  end

  private

  attr_reader :candidacy

  def render_progress
    { progress: candidacy.progress }
  end
end
