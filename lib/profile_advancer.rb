class ProfileAdvancer

  def self.call(user, profile)
    new(user, profile).call
  end

  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def call
    if next_profile_feature.present?
      next_candidate_profile_feature.inquire
    else
      user.tasks.create(taskable: user.candidate)
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :user, :profile

  def next_profile_feature
    @next_profile_feature ||= profile.features.next_for(candidate)
  end

  def next_candidate_profile_feature
    @next_candidate_profile_feature ||= candidate_profile_features.create(candidate_profile: candidate_profile)
  end

  def candidate_profile_features
    @candidate_profile_features ||= next_profile_feature.candidate_profile_features
  end

  def candidate_profile
    candidate.candidate_profile
  end

  def candidate
    @candidate ||= user.candidate
  end
end
