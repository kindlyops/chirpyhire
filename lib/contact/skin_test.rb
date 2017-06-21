class Contact::SkinTest < Contact::Attribute
  def label
    return 'Unknown' if candidacy.skin_test.nil?
    return 'Skin / TB Test' if candidacy.skin_test.present?

    'No Skin / TB Test'
  end

  def to_s
    candidacy.skin_test.present?.to_s
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.skin_test.nil?
    return 'fa-newspaper-o' if candidacy.skin_test.present?

    'fa-times-circle'
  end
end
