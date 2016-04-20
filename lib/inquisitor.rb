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
    lead.questions.unasked_recently_of(lead: lead).order(:created_at).first
  end

  def unasked_next_question
    @unasked_next_question ||= next_questions.unasked_recently_of(lead: lead).sample
  end

  def next_questions
    lead.next_questions_for(question)
  end

  def ask_question
    message = organization.ask(lead, question)
    inquiries.create(question: question, message: message)
  end

  def organization
    lead.organization
  end

  def inquiries
    lead.inquiries
  end
end
