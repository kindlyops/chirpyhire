class Caregiver::Handle < Caregiver::Attribute
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
