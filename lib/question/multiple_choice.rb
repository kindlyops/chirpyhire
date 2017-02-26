class Question::MultipleChoice < Question::Base
  POSTLUDE_BASE = 'Please reply with just the letter'.freeze
  THRESHOLD = 0.75
  BLOCK_SIZE = 1
  MAX_DISTANCE = 4

  def body
    <<~BODY
      #{question}

      #{choices_body}

      #{postlude}
    BODY
  end

  def choice?(message)
    body = clean(message.body)

    has?(choice(body)) || close?(body)
  end

  def answer
    Answer::MultipleChoice.new(self)
  end

  def postlude
    "#{POSTLUDE_BASE} #{choices_sentence}."
  end
  alias restated postlude

  private

  def has?(letter_choice)
    choices.keys.include?(letter_choice)
  end

  def choice(message)
    MULTIPLE_CHOICE_REGEXP.match(message)[1].to_sym
  end

  def close?(body)
    choices.values.any? do |value|
      value = clean(value)
      similarity(canonical: value, variant: body) >= THRESHOLD
    end
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

  def choices_sentence
    choices.keys.to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or '
    )
  end

  def choices_body
    choices.each_with_object('') do |(letter, value), body|
      body << "#{letter.capitalize}) #{value}\n"
    end
  end
end
