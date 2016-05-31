class ProfileAdvancer

  def self.call(candidate, profile)
    new(candidate, profile).call
  end

  def initialize(candidate, profile)
    @candidate = candidate
    @profile = profile
  end

  def call
    if next_profile_feature.present?
      next_candidate_feature.inquire
    else
      user.tasks.create(taskable: candidate)
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :candidate, :profile

  def next_profile_feature
    @next_profile_feature ||= profile.features.stale_for(candidate).first
  end

  def next_candidate_feature
    @next_candidate_feature ||= next_profile_feature.candidate_features.create(candidate: candidate)
  end

  def user
    @user ||= candidate.user
  end
end
