class ProfileAdvancer

  def self.call(candidate)
    new(candidate).call
  end

  def initialize(candidate)
    @candidate = candidate
  end

  def call
    if next_unasked_question.present? && user.subscribed?
      inquire
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
    @organization ||= user.organization
  end

  def next_unasked_question
    @next_unasked_question ||= begin
      questions = organization.candidate_persona.persona_features
      ids = user.inquiries.pluck(:persona_feature_id)
      questions.where.not(id: ids).where(deleted_at: nil).order(priority: :asc).first
    end
  end

  def inquire
    message = candidate.receive_message(body: next_unasked_question.question)
    message.create_inquiry(persona_feature: next_unasked_question)
  end

end
