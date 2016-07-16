class ProfileAdvancer

  def self.call(candidate)
    new(candidate).call
  end

  def initialize(candidate)
    @candidate = candidate
  end

  def call
    if next_unasked_question.present? && user.subscribed?
      next_unasked_question.inquire(user)
    else
      candidate.update(status: "Screened")
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :candidate

  def user
    @user ||= candidate.user
  end

  def organization
    user.organization
  end

  def next_unasked_question
    @next_unasked_question ||= organization.next_unasked_question_for(user)
  end
end
