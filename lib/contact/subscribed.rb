class Contact::Subscribed < Contact::Attribute
  def id
    candidacy.subscribed_to(organization).id
  end

  def label
    'Subscribed'
  end

  def search_label
    return 'Subscribed' if actively_subscribed?
  end

  def icon_class
    return 'fa-question' if contact.subscribed.nil?
    'fa-mobile'
  end

  def button_class
    return 'btn-secondary' if contact.send(attribute).present?

    'btn-outline-secondary'
  end

  def actively_subscribed?
    contact.subscribed?
  end

  def humanize_attributes
    label
  end
end
