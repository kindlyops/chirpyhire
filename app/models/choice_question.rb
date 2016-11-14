class ChoiceQuestion < Question
  has_paper_trail
  has_many :choice_question_options,
           foreign_key: :question_id, inverse_of: :choice_question
  accepts_nested_attributes_for :choice_question_options,
                                reject_if: :all_blank, allow_destroy: true
  validates :choice_question_options, presence: true

  def self.extract_internal(properties, message, inquiry)
    answer = message.body.strip.downcase
    choice_option = /\A([a-z]){1}\)?\z/.match(answer)[1]

    result = options(inquiry).find do |option|
      option.letter == choice_option
    end

    properties[:choice_option] = result.text
    properties
  end

  def self.child_class_property
    'choice'
  end

  def formatted_text
    return '' unless choice_question_options.present?
    <<-template
#{text}

#{choice_options_list}
Please reply with just the letter #{choice_options_letters_sentence}.
template
  end

  def choice_options_letters
    in_memory_sorted_options.map(&:letter)
  end

  def in_memory_sorted_options
    choice_question_options.sort_by(&:letter)
  end

  def options
    choice_question_options
  end

  private

  def choice_options_letters_sentence
    choice_options_letters.to_sentence(
      last_word_connector: ', or ',
      two_words_connector: ' or '
    )
  end

  def choice_options_list
    in_memory_sorted_options.each_with_object('') do |option, result|
      result << "#{option.letter}) #{option.text}\n"
    end
  end

  class << self
    private

    def choice_question(inquiry)
      question = inquiry.question
      question.becomes(question.type.constantize)
    end

    def historical_question(choice_question, inquiry)
      choice_question.paper_trail.version_at(inquiry.created_at, has_many: true)
    end

    def options(inquiry)
      question = inquiry.question
      choice_question = question.becomes(question.type.constantize)
      historical_question(choice_question, inquiry).choice_question_options
    end
  end
end
