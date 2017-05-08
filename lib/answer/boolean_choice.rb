class Answer::BooleanChoice < Answer::MultipleChoice
  def yes_variants
    %w(y yeah ya yup ye[a-z]{1})
  end

  def variants
    "#{no_variants.join('|')}|#{yes_variants.join('|')}"
  end

  def space_or_end_of_string
    '(?:\s|\z)'
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})#{space_or_end_of_string}")
  end

  def choice_map
    {
      'Yes, of course!' => true,
      'No, but I want it to be!' => false
    }
  end

  def regular_attribute(message)
    return unless regular_match(message).present?

    case regular_match(message)[1]
    when Regexp.new("\\A(#{yes_variants.join('|')})#{space_or_end_of_string}")
      true
    when Regexp.new("\\A(#{no_variants.join('|')})#{space_or_end_of_string}")
      false
    end
  end
end
