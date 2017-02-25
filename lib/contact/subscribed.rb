class Contact::Subscribed < Contact::Attribute
  def id
    candidacy.subscribed_to(organization).id
  end

  def label
    humanize_attribute(actively_subscribed?) || 'Unknown'
  end

  def search_label
    return 'Subscribed' if actively_subscribed?
  end

  def icon_class
    icon_classes[actively_subscribed?] || 'fa-question'
  end

  def actively_subscribed?
    contact.subscribed?
  end

  def button_class
    'btn-secondary'
  end

  def humanize_attributes
    {
      true => 'Subscribed',
      false => 'Unsubscribed'
    }
  end

  def icon_classes
    {
      true => 'fa-mobile subscribed',
      false => 'fa-mobile unsubscribed'
    }
  end
end
