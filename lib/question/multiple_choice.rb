class Question::MultipleChoice < Question::Base
  POSTLUDE_BASE = 'Please reply with just the letter'.freeze

  def body
    <<~BODY
      #{question}

      #{choices_body}

      #{postlude}
    BODY
  end

  def answer
    Answer::MultipleChoice.new(self)
  end

  def postlude
    "#{POSTLUDE_BASE} #{choices_sentence}."
  end
  alias restated postlude

  private

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
