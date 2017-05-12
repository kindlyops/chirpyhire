class Question::Zipcode < Question::Base
  def body
    <<~BODY
      What is your five-digit zipcode?

      This helps us find the best cases for you!
    BODY
  end

  def inquiry
    :zipcode
  end

  alias restated body

  def answer
    Answer::Zipcode.new(self)
  end
end
