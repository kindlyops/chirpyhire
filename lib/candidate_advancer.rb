# frozen_string_literal: true
class CandidateAdvancer
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    return if organization.over_message_limit? || user.unsubscribed?

    next_step
  end

  private

  attr_reader :user
  delegate :last_answer, :organization, :candidate, to: :user
  delegate :survey, to: :organization

  def next_step
    if initial_question?
      next_unasked_question.inquire(user, message_text: initial_message)
    elsif candidate_rejected?
      mark_as_bad_fit
    elsif next_unasked_question.present?
      next_unasked_question.inquire(user)
    else
      qualify_candidate
    end
  end

  def candidate_rejected?
    last_question.rejects?(candidate)
  end

  def initial_question?
    survey.questions.present? && user.inquiries.count.zero?
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
    "#{survey.welcome.body}\n\n#{subscription_notice}\n\n"\
    "#{next_unasked_question.formatted_text}"
  end

  def subscription_notice
    'If you ever wish to stop receiving text messages from '\
    "#{organization.name} just reply STOP."
  end

  def mark_as_bad_fit
    candidate.update(status: 'Bad Fit')
    send_bad_fit_notification
  end

  def qualify_candidate
    candidate.update(status: 'Qualified')
    AutomatonJob.perform_later(user, 'screen')
  end
end
