class Question::Experience < Question::Base
  def to_s
    <<~BODY
      Hello, this is #{organization.name}.
      We are hiring for multiple job openings!
      I am so glad you're interested in immediate
      work opportunities in the #{organization.city} area.

      We have a few questions to ask you via text message.
      We will give you a call to confirm at our earliest opportunity!

      How many years of private duty or home-care experience do you have?

      a) 0 - 1
      b) 1 - 5
      c) 6 or more
      d) I'm new to caregiving

      Please reply with just the letter a, b, c, or d.
    BODY
  end
end
