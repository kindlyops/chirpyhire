class YesNoQuestion < Question
  def self.extract(message, inquiry)
    question = inquiry.question
    yes_no_question = question.becomes(question.type.constantize)

    properties = {}
    properties[:child_class] = "yes_no"

    answer = message.body.strip.downcase
    yes_no_option = /\A(yes|no|y|n)\z/.match(answer)[1]

    properties[:yes_no_option] = yes_no_option
    properties
  end

  def formatted_text
    <<-template
#{text}

Please reply with just Yes or No.
template
  end
end
