class Answer::BooleanChoice < Answer::MultipleChoice
  def no_variants
    %w(nah nope no n)
  end

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
end
