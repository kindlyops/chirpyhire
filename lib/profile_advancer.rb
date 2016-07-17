class ProfileAdvancer

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    if next_unasked_question.present? && user.subscribed?
      next_unasked_question.inquire(user)
    else
      user.candidate.update(status: "Screened")
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :user

  def organization
    user.organization
  end

  def next_unasked_question
    @next_unasked_question ||= organization.next_unasked_question_for(user)
  end
end
