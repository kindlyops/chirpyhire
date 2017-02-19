class Answer::Base
  def initialize(question)
    @question = question
  end

  def valid?(*)
    false
  end

  attr_reader :question
end
