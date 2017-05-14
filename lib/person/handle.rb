class Person::Handle < Person::Attribute
  def label
    person.handle
  end

  def humanize_attribute(*)
    person.handle
  end

  def icon_class
    return 'fa-question' unless person.handle.present?

    'fa-user'
  end
end
