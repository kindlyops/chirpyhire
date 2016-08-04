class ChoiceQuestion < Question
  has_paper_trail
  has_many :choice_question_options, foreign_key: :question_id, inverse_of: :choice_question
  accepts_nested_attributes_for :choice_question_options, reject_if: :all_blank, allow_destroy: true

  def self.extract(message, question)
    properties = {}
    properties[:child_class] = "choice"

    answer = message.body.strip.downcase
    choice_option = /\A([a-z]){1}\)?\z/.match(answer)[1]

    option = question.choice_question_options.find_by(letter: choice_option)
    properties[:choice_option] = option.text
    properties
  end

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
    in_memory_sorted_options.map(&:letter)
  end

  def in_memory_sorted_options
    choice_question_options.sort_by(&:letter)
  end

  private

  def choice_options_letters_sentence
    choice_options_letters.to_sentence(last_word_connector: ", or ", two_words_connector: " or ")
  end

  def choice_options_list
    in_memory_sorted_options.each_with_object("") do |option, result|
      result << "#{option.letter}) #{option.text}\n"
    end
  end
end
