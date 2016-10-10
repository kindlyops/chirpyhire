class AnswerClassifier
  def initialize(answer, inquiry)
    @answer = answer
    @inquiry = inquiry
  end

  class NotClassifiedError < StandardError
  end

  def classify
    message = answer.message
    return DocumentQuestion if message.images?
    return AddressQuestion if message.address?
    return YesNoQuestion if message.yes_or_no?
    return ChoiceQuestion if message.choice?(choices)
    return WhitelistQuestion if message.whitelist?(whitelist_options)

    raise NotClassifiedError, 'Message was not succesfully classified
    to match any known question types.'
  end

  private

  attr_reader :answer, :inquiry

  def whitelist_options
    inquiry.question
           .becomes(WhitelistQuestion)
           .whitelist_question_options
           .pluck(:text)
  end

  def choice_question
    @choice_question ||= begin
      if inquiry.question_type == 'ChoiceQuestion'
        question = inquiry.question
        choice_question = question.becomes(question.type.constantize)
        find_version(choice_question)
      end
    end
  end

  def find_version(choice_question)
    choice_question.paper_trail.version_at(inquiry.created_at, has_many: true)
  end

  def choices
    return unless choice_question.present?
    choice_question.choice_options_letters.join
  end
end
