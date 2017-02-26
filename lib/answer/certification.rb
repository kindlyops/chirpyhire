class Answer::Certification < Answer::MultipleChoice
  def choice_map
    {
      'Yes, PCA' => :pca,
      'Yes, CNA' => :cna,
      'Yes, Other (MA, LPN, RN, etc.)' => :other_certification,
      'No' => :no_certification
    }
  end
end
