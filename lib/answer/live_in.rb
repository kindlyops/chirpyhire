class Answer::LiveIn < Answer::BooleanChoice
  def choice_map
    {
      "Yes, I'd love to!" => true,
      'No, not for now!' => false
    }
  end
end
