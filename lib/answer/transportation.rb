class Answer::Transportation < Answer::MultipleChoice
  def choice_map
    {
      'I have personal transportation.' => :personal,
      'I use public transportation.' => :public,
      'I do not have reliable transportation.' => :none
    }
  end

  def attribute(message)
    attribute = choice_map[question.choices[choice(message)]]

    { question.inquiry => attribute }
  end
end
