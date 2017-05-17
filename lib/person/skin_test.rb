class Person::SkinTest < Person::Attribute
  def label
    'Skin / TB Test'
  end

  def to_s
    candidacy.skin_test.present?.to_s
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.skin_test.nil?

    'fa-newspaper-o'
  end
end