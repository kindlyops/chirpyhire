class Answer::Transportation < Answer::MultipleChoice
  def choice_map
    {
      'I have personal transportation' => :personal_transportation,
      'I use public transportation' => :public_transportation,
      'I do not have reliable transportation' => :no_transportation
    }
  end

  def positive_variants
    %w(personal public).concat(choice_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:transportation)?\\z")
  end
end
