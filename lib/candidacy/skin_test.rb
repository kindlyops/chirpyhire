class Candidacy::SkinTest < Candidacy::Attribute
  def label
    'Skin / TB Test'
  end

  def humanize_attribute(*)
    'Skin / TB Test'
  end

  def icon_class
    return 'fa-question' unless candidacy.skin_test.present?

    'fa-newspaper-o'
  end
end
