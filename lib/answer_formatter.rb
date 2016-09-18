class AnswerFormatter
  def initialize(answer, inquiry)
    @answer = answer
    @inquiry = inquiry
  end

  def format
    return 'DocumentQuestion' if message.has_images?
    return 'AddressQuestion' if message.has_address?
    return 'YesNoQuestion' if message.has_yes_or_no?
    return 'ChoiceQuestion' if message.has_choice?(choices)
    'Unknown Format'
  end

  private

  attr_reader :answer, :inquiry

  def choice_question
    @choice_question ||= begin
      if inquiry.question_type == 'ChoiceQuestion'
        question = inquiry.question
        choice_question = question.becomes(question.type.constantize)
        choice_question.paper_trail.version_at(inquiry.created_at, has_many: true)
      end
    end
  end

  def choices
    return unless choice_question.present?
    choice_question.choice_options_letters.join
  end

  def message
    @message ||= answer.message
  end
end
