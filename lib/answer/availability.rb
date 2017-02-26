class Answer::Availability < Answer::MultipleChoice
  def choice_map
    {
      'Live-In' => :live_in,
      'Hourly' => :hourly,
      'Both' => :both,
      'No Availability' => :no_availability
    }
  end
end
