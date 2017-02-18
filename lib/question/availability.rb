class Question::Availability < Question::Base
  def to_s
    <<~BODY
      What is your availability?

      a) Live-In
      b) Full-Time
      c) Part-Time
      d) All the above

      Please reply with just the letter a, b, c, or d.
    BODY
  end
end
