class ProfileAdvancer

  def self.call(candidate)
    new(candidate).call
  end

  def initialize(candidate)
    @candidate = candidate
  end

  def call
    if next_ideal_feature.present?
      next_candidate_feature.inquire
    else
      candidate.update(screened: true)
      candidate.create_activity :screen, outstanding: true, owner: user
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :candidate

  def next_ideal_feature
    @next_ideal_feature ||= candidate.next_ideal_feature
  end

  def next_candidate_feature
    @next_candidate_feature ||= candidate.features.create(ideal_feature: next_ideal_feature)
  end

  def user
    @user ||= candidate.user
  end
end
