class Question::CprFirstAid < Question::Base
  def to_s
    <<~BODY
      Is your CPR / First Aid certification up to date?

      Please reply with just Yes or No.
    BODY
  end
end
