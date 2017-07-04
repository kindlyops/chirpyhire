class Answer::MultipleChoice < Answer::Base
  delegate :choices, to: :question

  def multiple_choice_regexp
    Regexp.new("\\A([#{choices.keys.join(',')}])(\\z|[\\W]+.*\\z)")
  end

  def valid?(message)
    choice?(message) || regular_choice?(message)
  end

  def attribute(message)
    attribute = fetch_attribute(message)

    { question.inquiry => attribute }
  end

  private

  def regular_choice?(message)
    (answer_regexp =~ clean(message.body)).present?
  end

  def choice?(message)
    choices.keys.include?(choice(message))
  end

  def fetch_attribute(message)
    return regular_attribute(message) if choice_attribute(message).nil?

    choice_attribute(message)
  end

  def choice_attribute(message)
    choice_map[choices[choice(message)]]
  end

  def choice(message)
    return if match(message).blank?
    match(message)[1].to_sym
  end

  def match(message)
    multiple_choice_regexp.match(clean(message.body))
  end

  def regular_match(message)
    answer_regexp.match(clean(message.body))
  end

  def clean(string)
    string.downcase.squish
  end

  def regular_variants
    choice_map.keys.map { |variant| Regexp.escape(variant.downcase) }
  end

  def no_variants
    %w[nah nope no n]
  end
end