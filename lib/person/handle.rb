class Person::Handle < Person::Attribute
  def label
    person.handle
  end

  def humanize_attribute(*)
    person.handle
  end

  def icon_class
    return 'fa-question' if person.handle.blank?

    'fa-user'
  end
end
