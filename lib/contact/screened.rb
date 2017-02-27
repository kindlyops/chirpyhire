class Contact::Screened < Contact::Attribute
  def label
    'Screened'
  end

  def to_s
    value.to_s
  end

  def value
    contact.screened.present?
  end

  def search_label
    label if contact.screened.present?
  end
end
