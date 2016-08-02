class Choice
  def self.extract(message, question)
    properties = {}
    properties[:child_class] = "choice"

    answer = message.body.strip.downcase
    choice_option = /\A([a-z]){1}\)?\z/.match(answer)[1]

    option = question.choice_question_options.find_by(letter: choice_option)
    if option.present?
      properties[:choice_option] = option.text
    end
    properties
  end

  def initialize(feature)
    @feature = feature
  end

  def option
    feature.properties['choice_option']
  end

  def category
    feature.category.name
  end

  private

  attr_reader :feature
end
