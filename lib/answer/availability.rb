class Answer::Availability < Answer::MultipleChoice
  def choice_map
    {
      'Live-In' => :live_in,
      'Hourly' => :hourly,
      'Both' => :both,
      'No Availability' => :no_availability
    }
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

  def regular_attribute(message)
    return unless regular_match(message).present?

    case regular_match(message)[1]
    when 'live in', 'live-in'
      :live_in
    when 'hourly'
      :hourly
    when 'both'
      :both
    when *no_variants.concat(no_variants.map { |v| "#{v} availability" })
      :no_availability
    end
  end
end
