class ChoiceQuestion < Question
  has_many :choice_question_options, foreign_key: :question_id, inverse_of: :question

  def choice_template
    return "" unless choice_question_options.present?
    <<-template
#{text}

#{choice_options_list}

Please reply with just the letter #{choice_options_letters_sentence}.
template
  end

  def question
    choice_template
  end

  def choice_options_letters
    choice_question_options.map(&:letter)
  end

  private

  def choice_options_letters_sentence
    choice_options_letters.to_sentence(last_word_connector: ", or ", two_words_connector: " or ")
  end

  def choice_options_list
    choice_question_options.each_with_object("") do |option, result|
      result << "#{option.letter}) #{option.text}\n"
    end
  end
end
