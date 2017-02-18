class Question::Zipcode < Question::Base
  def to_s
    <<~BODY
      What is your five-digit zipcode?
    BODY
  end
end
