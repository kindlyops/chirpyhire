class Answer::Availability < Answer::MultipleChoice
  def choice_map
    {
      'Live-In' => :live_in,
      'Hourly' => :hourly,
      'Both' => :both,
      'No Availability' => :no_availability
    }
  end

  def no_variants
    %w(nah nope no n)
  end

  def positive_variants
    ['live in', 'live-in', 'hourly', 'both']
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:availability)?\\z")
  end
end
