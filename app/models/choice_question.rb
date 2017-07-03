class ChoiceQuestion < Question
  POSTLUDE_BASE = 'Please reply with just the letter'.freeze

  def body(formatted: true)
    return self[:body] if formatted.blank?

    <<~BODY.strip
      #{self[:body]}

      #{choices_body}
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

  private

  def choices_body
    follow_ups.each_with_object('') do |follow_up, body|
      body << "#{follow_up.choice.capitalize} - #{follow_up.response}\n"
    end
  end

  def choices_sentence
    follow_ups.map(&:choice).map(&:upcase).to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or '
    )
  end
end
