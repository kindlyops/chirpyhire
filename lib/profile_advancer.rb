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
      send_unacceptable_notification
    elsif next_unasked_question.present?
      next_unasked_question.inquire(user)
    else
      candidate.update(status: "Screened")
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
    AnswerRejector.new(candidate, last_persona_feature, last_answer).call
  end

  def last_persona_feature
    @last_persona_feature ||= last_answer.persona_feature
  end

  def next_unasked_question
    @next_unasked_question ||= organization.next_unasked_question_for(user)
  end

  def send_unacceptable_notification
    last_persona_feature.template.perform(user)
  end
end
