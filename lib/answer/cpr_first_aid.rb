class Answer::CprFirstAid < Answer::MultipleChoice
  def choice_map
    {
      'Yes' => true,
      'No' => false
    }
  end
end
