class ProfileAdvancer

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    return unless user.subscribed?

    if initial_question?
      next_unasked_question.inquire(user, message_text: initial_message)
    elsif answer_rejected?
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
  delegate :last_answer, :organization, :candidate, to: :user
  delegate :survey, to: :organization

  def initial_question?
    user.inquiries.count.zero?
  end

  def answer_rejected?
    AnswerRejector.new(candidate, last_question).call
  end

  def last_question
    @last_question ||= last_answer.question
  end

  def next_unasked_question
    @next_unasked_question ||= survey.next_unasked_question_for(user)
  end

  def send_bad_fit_notification
    last_question.bad_fit.perform(user)
  end

  def initial_message
    "#{survey.welcome.body}\n\n#{subscription_notice}\n\n#{next_unasked_question.text}"
  end

  def subscription_notice
    "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
  end
end
