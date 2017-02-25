class Contact::SkinTest < Contact::Attribute
  def label
    'Skin / TB Test'
  end

  def humanize_attribute(*)
    label
  end

  def search_label
    label if candidacy.skin_test.present?
  end

  def icon_class
    return 'fa-question' if candidacy.skin_test.nil?

    'fa-newspaper-o'
  end
end
