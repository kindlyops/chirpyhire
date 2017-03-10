class Answer::Certification < Answer::MultipleChoice
  def choice_map
    {
      'Yes, PCA' => :pca,
      'Yes, CNA' => :cna,
      'Yes, Other (MA, LPN, RN, etc.)' => :other_certification,
      'Not Yet, but I want to be!' => :no_certification
    }
  end

  def positive_variants
    %w(pca cna other ma lpn rn cna rca hha).concat(regular_variants)
  end

  def variants
    "#{positive_variants.join('|')}|#{no_variants.join('|')}"
  end

  def no_variants
    super.push('not yet')
  end

  def answer_regexp
    Regexp.new("\\A(#{variants})\\s?(?:certification)?\\z")
  end

  def regular_attribute(message)
    return unless regular_match(message).present?

    regular_case(message)
  end

  def regular_case(message)
    case regular_match(message)[1]
    when 'pca', 'yes, pca'
      :pca
    when 'cna', 'yes, cna'
      :cna
    when *other_variants
      :other_certification
    when *no_variants.concat(no_variants.map { |v| "#{v} certification" })
      :no_certification
    end
  end

  def other_variants
    ['other', 'ma', 'lpn', 'rn', 'rca', 'hha', 'yes, other (ma, lpn, rn, etc.)']
  end
end
