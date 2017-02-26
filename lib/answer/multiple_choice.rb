class Answer::MultipleChoice < Answer::Base
  MULTIPLE_CHOICE_REGEXP = /\A([a-z]){1}\)?\z/

  def valid?(message)
    question.choice?(message)
  end

  def attribute(message)
    attribute = question.choices[choice(message)]
                        .downcase
                        .parameterize
                        .underscore
                        .to_sym

    { question.inquiry => attribute }
  end
end
