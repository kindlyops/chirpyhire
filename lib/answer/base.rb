class Answer::Base
  def initialize(question)
    @question = question
  end

  def valid?(_message)
    false
  end

  attr_reader :question
end
