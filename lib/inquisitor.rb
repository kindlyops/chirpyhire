class Inquisitor

  def initialize(lead:, question:)
    @lead = lead
    @question = question
  end

  def call
    lead.ask(question)

    # return unless question.present?

    # if lead.recently_answered?(question)
    #   question.next_question.ask(lead: lead)
    # end
  end

  private

  attr_reader :lead, :question
end
