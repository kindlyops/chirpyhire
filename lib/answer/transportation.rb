class Answer::Transportation < Answer::MultipleChoice
  def choice_map
    {
      'I have personal transportation' => :personal_transportation,
      'I use public transportation' => :public_transportation,
      'I do not have reliable transportation' => :no_transportation
    }
  end

  def positive_variants
    %w(personal public).concat(regular_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:transportation)?\\z")
  end

  def regular_attribute(message)
    case answer_regexp.match(clean(message.body))[1]
    when 'personal', 'I have personal transportation'.downcase
      :personal_transportation
    when 'public', 'I use public transportation'.downcase
      :public_transportation
    when *no_case_variants
      :no_transportation
    end
  end

  def no_case_variants
    no_variants
      .concat(no_variants.map { |v| "#{v} transportation" })
      .push('I do not have reliable transportation'.downcase)
  end
end
