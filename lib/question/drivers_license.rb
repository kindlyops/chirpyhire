class Question::DriversLicense < Question::MultipleChoice
  def question
    "Do you have a current Driver's License?"
  end

  def choices
    {
      a: 'Yes, of course!',
      b: 'No, but I want to get one!'
    }
  end

  def inquiry
    :drivers_license
  end

  def answer
    Answer::DriversLicense.new(self)
  end
end
