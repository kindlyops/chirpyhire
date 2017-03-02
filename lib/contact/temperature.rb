class Contact::Temperature
  def initialize(contact)
    @contact = contact
  end

  def label
    'Hot'
  end

  def icon_class
    'fa-thermometer-full'
  end

  def badge_class
    'badge-danger'
  end
end
