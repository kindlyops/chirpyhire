class Answer::BooleanChoice < Answer::MultipleChoice
  def yes_variants
    %w(yes y yeah ya yup ye[a-z]{1}).push('yes\s.*')
  end

  def answer_regexp
    Regexp.new("\\A(#{no_variants.join('|')}|#{yes_variants.join('|')})\\z")
  end

  def choice_map
    {
      'Yes' => true,
      'No' => false
    }
  end

  def regular_attribute(message)
    case answer_regexp.match(clean(message.body))[1]
    when 'y', 'yeah', 'ya', 'yup', /\Aye[a-z]{1}\z/, /\Ayes\s.*\z/
      true
    when 'nah', 'nope', 'no', 'n'
      false
    end
  end
end
