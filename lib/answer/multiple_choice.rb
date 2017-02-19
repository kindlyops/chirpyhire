class Answer::MultipleChoice < Answer::Base
  MULTIPLE_CHOICE_REGEXP = /\A([a-z]){1}\)?\z/

  def valid?(message)
    cleaned_body = message.body.strip.downcase
    choice = MULTIPLE_CHOICE_REGEXP.match(cleaned_body)[1]

    question.has?(choice)
  end
end
