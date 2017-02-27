class Answer::Experience < Answer::MultipleChoice
  def choice_map
    {
      '0 - 1' => :less_than_one,
      '1 - 5' => :one_to_five,
      '6 or more' => :six_or_more,
      "I'm new to caregiving" => :no_experience
    }
  end

  def no_variants
    %w(no)
  end

  def positive_variants
    ['\d\s?-\s?\d', '\d', 'new to caregiving'].concat(choice_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:experience)?\\z")
  end
end
