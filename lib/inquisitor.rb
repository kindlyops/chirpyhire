class Inquisitor

  def initialize(lead:, question:)
    @lead = lead
    @question = question
  end

  def call
    if lead.has_unanswered_recent_inquiry?
    #   # ask again in the near future
    elsif lead.recently_answered?(question)
      attempt_next_inquiry
    else
      ask_question
    end
  end

  private

  def ask_question
    message = organization.ask(lead, question)
    inquiries.create(question: question, message: message)
  end

  attr_reader :lead, :question

  def attempt_next_inquiry
    return unless follow_up_question.present?
    Inquisitor.new(lead: lead, question: follow_up_question).call
  end

  def follow_up_question
    @follow_up_question ||= begin
      if unasked_next_question.present?
        unasked_next_question
      else
        oldest_unasked_question
      end
    end
  end

  def oldest_unasked_question
    questions_unasked_recently.order(:created_at).first
  end

  def questions_unasked_recently
    @questions_unasked_recently ||= lead.questions_unasked_recently
  end

  def unasked_next_question
    @unasked_next_question ||= questions_unasked_recently.merge(next_questions).sample
  end

  def next_questions
    lead.next_questions_for(question)
  end

  def organization
    lead.organization
  end

  def inquiries
    lead.inquiries
  end
end
