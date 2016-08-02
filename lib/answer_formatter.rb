class AnswerFormatter
  def initialize(answer, question)
    @answer = answer
    @question = question
  end

  def format
    return "DocumentQuestion" if message.has_images?
    return "AddressQuestion" if message.has_address?
    return "ChoiceQuestion" if message.has_choice?(choices)
    "Unknown Format"
  end

  private

  attr_reader :answer, :question

  def choices
    return unless question.has_choices?

    question.choice_options_letters.join
  end

  def message
    @message ||= answer.message
  end
end
