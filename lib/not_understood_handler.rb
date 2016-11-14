class NotUnderstoodHandler
  THRESHOLD = 4
  def self.notify(user, inquiry)
    user.update!(has_unread_messages: true)
    return if inquiry.not_understood_count >= THRESHOLD
    user.organization_survey.not_understood.perform(user)
    inquiry.update!(not_understood_count: inquiry.not_understood_count + 1)
  end
end
