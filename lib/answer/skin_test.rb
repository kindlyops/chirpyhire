class Answer::SkinTest < Answer::MultipleChoice
  def choice_map
    {
      'Yes' => true,
      'No' => false
    }
  end

  def attribute(message)
    attribute = choice_map[question.choices[choice(message)]]

    { question.inquiry => attribute }
  end
end
