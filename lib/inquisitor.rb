class Inquisitor

  def initialize(lead:, question:)
    @lead = lead
    @question = question
  end

  def call
    return unless question.present?

    if lead.has_recent_unanswered_inquiry?
      # ask again in the near future
    elsif lead.recently_answered?(question)
      attempt_next_inquiry
    else
      lead.ask(question)
    end
  end

  private

  attr_reader :lead, :question

  def attempt_next_inquiry

  end

  # def attempt_next_inquiry
  #   Inquisitor.new(lead: self, question: next_question).call
  # end

  # def next_question
  #   searches.next_question_for(self)
  # end
end
