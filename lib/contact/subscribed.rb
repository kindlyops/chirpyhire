class Contact::Subscribed < Contact::Attribute
  def id
    candidacy.subscribed_to(organization).id
  end

  def to_s
    contact.subscribed?.to_s
  end

  def label
    'Subscribed'
  end

  def search_label
    label if contact.subscribed?
  end

  def icon_class
    return 'fa-question' if contact.subscribed.nil?
    'fa-mobile'
  end

  def button_class
    return 'btn-secondary' if contact.subscribed?

    'btn-outline-secondary'
  end

  def humanize_attributes
    label
  end
end
