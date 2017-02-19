class Answer::Certification < Answer::MultipleChoice
  def choice_map
    {
      'Yes, PCA' => :pca,
      'Yes, CNA' => :cna,
      'Yes, Other (MA, LPN, RN, etc.)' => :other,
      'No' => :none
    }
  end

  def attribute(message)
    attribute = choice_map[question.choices[choice(message)]]

    { question.inquiry => attribute }
  end
end
