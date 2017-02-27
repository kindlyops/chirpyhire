class Answer::Certification < Answer::MultipleChoice
  def choice_map
    {
      'Yes, PCA' => :pca,
      'Yes, CNA' => :cna,
      'Yes, Other (MA, LPN, RN, etc.)' => :other_certification,
      'No' => :no_certification
    }
  end

  def positive_variants
    %w(pca cna other ma lpn rn cna rca hha).concat(choice_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:certification)?\\z")
  end
end
