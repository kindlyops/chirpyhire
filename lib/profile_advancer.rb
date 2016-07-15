class ProfileAdvancer

  def self.call(candidate)
    new(candidate).call
  end

  def initialize(candidate)
    @candidate = candidate
  end

  def call
    if next_persona_feature.present? && user.subscribed?
      next_candidate_feature.inquire
    else
      candidate.update(status: "Screened")
      candidate.create_activity :screen, outstanding: true, owner: user
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :candidate

  def next_persona_feature
    @next_persona_feature ||= candidate.next_persona_feature
  end

  def next_candidate_feature
    @next_candidate_feature ||= candidate.features.create(persona_feature: next_persona_feature)
  end

  def user
    @user ||= candidate.user
  end
end
