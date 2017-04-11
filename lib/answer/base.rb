class Answer::Base
  def initialize(question)
    @question = question
  end

  def valid?(*)
    false
  end

  def attribute(*)
    {}
  end

  def format(message)
    yield attribute(message) if block_given?
  end

  attr_reader :question
end
