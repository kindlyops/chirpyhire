class Question::SkinTest < Question::Base
  def to_s
    <<~BODY
      Is your TB skin test or X-ray up to date?

      Please reply with just Yes or No.
    BODY
  end
end
