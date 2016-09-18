class AnswerFormatter
  def initialize(answer, inquiry)
    @answer = answer
    @inquiry = inquiry
  end

  def format
    return 'DocumentQuestion' if message.images?
    return 'AddressQuestion' if message.address?
    return 'YesNoQuestion' if message.yes_or_no?
    return 'ChoiceQuestion' if message.choice?(choices)
    'Unknown Format'
  end

  private

  attr_reader :answer, :inquiry

  def choice_question
    @choice_question ||= begin
      if inquiry.question_type == 'ChoiceQuestion'
        question = inquiry.question
        choice_question = question.becomes(question.type.constantize)
        version(choice_question)
      end
    end
  end

  def version(choice_question)
    choice_question.paper_trail.version_at(inquiry.created_at, has_many: true)
  end

  def choices
    return unless choice_question.present?
    choice_question.choice_options_letters.join
  end

  def message
    @message ||= answer.message
  end
end
