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
      candidate.running! if candidate.candidate_features.empty?
      next_candidate_feature.inquire
    else
      candidate.finished!
      user.tasks.create(taskable: user.candidate)
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :user, :profile

  def next_profile_feature
    @next_profile_feature ||= profile.features.next_for(candidate)
  end

  def next_candidate_feature
    @next_candidate_feature ||= candidate_features.create(candidate: candidate)
  end

  def candidate_features
    @candidate_features ||= next_profile_feature.candidate_features
  end

  def candidate
    @candidate ||= user.candidate
  end
end
