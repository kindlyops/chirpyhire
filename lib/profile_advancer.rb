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
      next_user_feature.inquire
    else
      user.tasks.create(taskable: user.candidate)
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :user, :profile

  def next_profile_feature
    @next_profile_feature ||= profile.features.next_for(user)
  end

  def next_user_feature
    @next_user_feature ||= next_profile_feature.user_features.create(user: user)
  end
end
