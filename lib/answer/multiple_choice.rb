class Answer::MultipleChoice < Answer::Base
  MULTIPLE_CHOICE_REGEXP = /\A([a-z]){1}\)?\z/
  THRESHOLD = 0.49
  delegate :choices, to: :question

  def valid?(message)
    choice?(message) || approximate_choice?(message)
  end

  def attribute(message)
    attribute = choice_map[fetch_attribute(message)]

    { question.inquiry => attribute }
  end

  private

  def choice?(message)
    choices.keys.include?(choice(message))
  end

  def approximate_choice?(message)
    body = clean(message.body)
    result = fuzzy_match.find(body, threshold: THRESHOLD)

    log_result(message, result) if result.present?
    false
  end

  def log_result(message, result)
    Rollbar.info('Answer::MultipleChoice Approximate: ', message.body, result)
  end

  def fuzzy_match
    FuzzyMatch.new(choices.values)
  end

  def fetch_attribute(message)
    choices[choice(message)]
  end

  def choice(message)
    return unless match(message).present?
    match(message)[1].to_sym
  end

  def match(message)
    MULTIPLE_CHOICE_REGEXP.match(clean(message.body))
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
