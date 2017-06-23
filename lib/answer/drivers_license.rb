class Answer::DriversLicense < Answer::BooleanChoice
  def choice_map
    {
      'Yes, of course!' => true,
      'No, but I want to get one!' => false
    }
  end
end
