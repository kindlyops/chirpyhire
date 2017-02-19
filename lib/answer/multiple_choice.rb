class Answer::MultipleChoice < Answer::Base
  MULTIPLE_CHOICE_REGEXP = /\A([a-z]){1}\)?\z/

  def valid?(message)
    question.has?(choice(message))
  end

  def attribute(message)
    attribute = question.choices[choice(message)]
                        .downcase
                        .parameterize
                        .underscore
                        .to_sym

    { question.inquiry => attribute }
  end

  private

  def choice(message)
    MULTIPLE_CHOICE_REGEXP.match(clean_body(message))[1]
  end

  def clean_body(message)
    message.body.strip.downcase
  end
end
