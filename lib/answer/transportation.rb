class Answer::Transportation < Answer::MultipleChoice
  def choice_map
    {
      'I have personal transportation.' => :personal_transportation,
      'I use public transportation.' => :public_transportation,
      'I do not have reliable transportation.' => :no_transportation
    }
  end
end
