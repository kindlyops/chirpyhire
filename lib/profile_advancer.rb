class ProfileAdvancer

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    return unless user.subscribed?

    if answer_rejected?
      candidate.update(status: "Bad Fit")
      send_bad_fit_notification
    elsif next_unasked_question.present?
      next_unasked_question.inquire(user)
    else
      candidate.update(status: "Qualified")
      AutomatonJob.perform_later(user, "screen")
    end
  end

  private

  attr_reader :user
  delegate :last_answer, to: :user

  def organization
    user.organization
  end

  def candidate
    @candidate ||= user.candidate
  end

  def answer_rejected?
    AnswerRejector.new(candidate, last_question).call
  end

  def last_question
    @last_question ||= last_answer.question
  end

  def next_unasked_question
    @next_unasked_question ||= organization.next_unasked_question_for(user)
  end

  def send_bad_fit_notification
    last_question.template.perform(user)
  end
end
