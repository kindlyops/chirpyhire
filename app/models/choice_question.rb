class ChoiceQuestion < Question
  POSTLUDE_BASE = 'Please reply with just the letter'.freeze

  def body(formatted: true)
    return self[:body] if formatted.blank?

    <<~BODY.strip
      #{self[:body]}

      #{answers}
      #{postlude}
    BODY
  end

  def postlude
    "#{POSTLUDE_BASE} #{choices_sentence}."
  end
  alias restated postlude

  def follow_up_type
    'ChoiceFollowUp'
  end

  def answers
    follow_ups.each_with_object('') do |follow_up, body|
      body << "#{follow_up.choice.capitalize} - #{follow_up.response}\n"
    end
  end

  private

  def choices_sentence
    follow_ups.map(&:choice).map(&:upcase).to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or '
    )
  end
end
