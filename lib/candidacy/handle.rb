class Candidacy::Handle < Candidacy::Attribute
  def label
    candidacy.handle
  end

  def humanize_attribute(*)
    candidacy.handle
  end

  def icon_class
    return 'fa-question' unless candidacy.handle.present?

    'fa-user'
  end
end
