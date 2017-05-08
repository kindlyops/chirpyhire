class Question::Zipcode < Question::Base
  def body
    <<~BODY
      What is your five-digit zipcode? Let's get you jobs close to home!
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
