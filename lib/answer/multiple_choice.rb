class Answer::MultipleChoice < Answer::Base
  MULTIPLE_CHOICE_REGEXP = /\A([a-z]){1}\)?\z/
  THRESHOLD = 0.75
  BLOCK_SIZE = 1
  MAX_DISTANCE = 4
  delegate :choices, to: :question

  def valid?(message)
    choice?(choice(message)) || approximate_choice?(message)
  end

  def attribute(message)
    attribute = fetch_attribute(message)

    { question.inquiry => attribute }
  end

  private

  def choice?(option)
    choices.keys.include?(option)
  end

  def approximate_choice?(message)
    body = clean(message.body)

    choices.values.any? do |value|
      value = clean(value)
      similarity(canonical: value, variant: body) >= THRESHOLD
    end
  end

  def fetch_attribute(message)
    option = fetch_option(message)
    return unless option.present?

    choices[option]
      .downcase
      .parameterize
      .underscore
      .to_sym
  end

  def fetch_option(message)
    if choice(message).present?
      choice(message)
    else
      approximate_choice(message)
    end
  end

  def approximate_choice(message)
    body = clean(message.body)

    choice = choices.find do |_option, value|
      value = clean(value)
      similarity(canonical: value, variant: body) >= THRESHOLD
    end

    choice.first if choice.present?
  end

  def choice(message)
    MULTIPLE_CHOICE_REGEXP.match(clean(message.body))[1].to_sym
  end

  def similarity(canonical:, variant:)
    1.0 / distance(canonical: canonical, variant: variant)
  end

  def distance(canonical:, variant:)
    DamerauLevenshtein.distance(canonical, variant, BLOCK_SIZE, MAX_DISTANCE)
  end

  def clean(string)
    string.downcase.gsub(/[^a-z0-9\s]/i, '').squish
  end
end
