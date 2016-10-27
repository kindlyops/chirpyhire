class NotUnderstoodHandler
  THRESHOLD = 4
  def self.notify(user, inquiry)
    return if inquiry.not_understood_count >= THRESHOLD
    user.organization_survey.not_understood.perform(user)
    inquiry.increment!(:not_understood_count)
  end
end
