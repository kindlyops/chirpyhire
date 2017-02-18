class Question::Certification < Question::Base
  def to_s
    <<~BODY
      Are you currently licensed or certified?

      a) Yes, PCA
      b) Yes, CNA
      c) Yes, Other (MA, LPN, RN, etc.)
      d) No

      Please reply with just the letter a, b, c, or d.
    BODY
  end
end
