class Answer::Availability < Answer::MultipleChoice
  def choice_map
    {
      'Live-In' => :live_in,
      'Hourly - AM' => :hourly_am,
      'Hourly - PM' => :hourly_pm,
      'Wide open for any shifts!' => :open
    }
  end

  def positive_variants
    ['live in', 'live-in', 'am', 'pm', 'open', 'any shift']
  end

  def variants
    positive_variants.join('|').to_s
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:availability)?\\z")
  end

  def regular_attribute(message)
    return unless regular_match(message).present?

    regular_case(message)
  end

  def regular_case(message)
    case regular_match(message)[1]
    when 'live in', 'live-in'
      :live_in
    when 'am'
      :hourly_am
    when 'pm'
      :hourly_pm
    when 'open', 'any shift'
      :open
    end
  end
end
