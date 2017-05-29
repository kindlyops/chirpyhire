class Answer::Availability < Answer::MultipleChoice
  def choice_map
    {
      'Morning (AM) shifts are great!' => :hourly_am,
      'Evening (PM) shifts are great!' => :hourly_pm,
      "I'm wide open for AM or PM shifts!" => :hourly
    }
  end

  def positive_variants
    ['am', 'pm', 'open', 'any shift', 'hourly']
  end

  def variants
    positive_variants.join('|')
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:availability)?\\z")
  end

  def regular_attribute(message)
    return if regular_match(message).blank?

    regular_case(message)
  end

  def regular_case(message)
    case regular_match(message)[1]
    when 'am'
      :hourly_am
    when 'pm'
      :hourly_pm
    when 'open', 'any shift', 'hourly'
      :hourly
    end
  end
end
