class Answer::Experience < Answer::MultipleChoice
  def choice_map
    {
      '0 - 1' => :less_than_one,
      '1 - 5' => :one_to_five,
      '6 or more' => :six_or_more,
      "I'm new to caregiving" => :no_experience
    }
  end

  def attribute(message)
    attribute = choice_map[question.choices[choice(message)]]

    { question.inquiry => attribute }
  end
end
