class Question::Experience < Question::MultipleChoice
  def question
    <<~QUESTION
      Hello, this is #{organization.name}.
      We are hiring for multiple job openings!
      We are so glad you're interested in immediate
      work opportunities in the #{organization.city} area.

      We have a few questions to ask you via text message.
      We will give you a call to confirm at our earliest opportunity!

      How many years of private duty or home-care experience do you have?
    QUESTION
  end

  def choices
    {
      a: '0 - 1',
      b: '1 - 5',
      c: '6 or more',
      d: "I'm new to caregiving"
    }
  end

  def inquiry
    :experience
  end
end
