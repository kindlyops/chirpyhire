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
    ['0\s?-\s?1', '1\s?-\s?5', '\d{1,2}', 'new to caregiving']
      .concat(regular_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:experience)?\\z")
  end

  def regular_attribute(message)
    case answer_regexp.match(clean(message.body))[1]
    when /\A0\s?-\s?1\z/, '0'
      :less_than_one
    when /\A1\s?-\s?5\z/, '1', '2', '3', '4', '5'
      :one_to_five
    when '6', '6 or more', /\A\d{1,2}\z/
      :six_or_more
    when *no_case_variants
      :no_experience
    end
  end

  def no_case_variants
    no_variants
      .concat(no_variants.map { |v| "#{v} experience" })
      .push("I'm new to caregiving".downcase)
  end
end
