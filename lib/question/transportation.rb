class Question::Transportation < Question::Base
  def to_s
    <<~BODY
      Do you have reliable transportation?

      a) I have personal transportation.
      b) I use public transportation.
      c) I do not have reliable transportation.

      Please reply with just the letter a, b, or c.
    BODY
  end
end
