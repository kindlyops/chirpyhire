class Question::MultipleChoice < Question::Base
  POSTLUDE_BASE = 'Please reply with just the letter'.freeze

  def body
    <<~BODY
      #{question}

      #{choices_body}

      #{postlude}
    BODY
  end

  def has?(choice)
    choices.keys.include?(choice)
  end

  def answer
    Answer::MultipleChoice.new(self)
  end

  private

  def postlude
    "#{POSTLUDE_BASE} #{choices_sentence}."
  end
  alias restated postlude

  def choices_sentence
    choices.keys.to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or '
    )
  end

  def choices_body
    choices.each_with_object('') do |(letter, value), body|
      body << "#{letter}) #{value}\n"
    end
  end
end
