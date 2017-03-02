class Contact::Temperature
  def initialize(contact)
    @contact = contact
  end

  def label
    return 'Hot' if hot?
    return 'Warm' if warm?
    'Cool'
  end

  def search_label
    label
  end

  def icon_class
    return 'fa-thermometer-full' if hot?
    return 'fa-thermometer-half' if warm?
    'fa-thermometer-quarter'
  end

  def badge_class
    return 'badge-danger' if hot?
    return 'badge-warning' if warm?
    'badge-success'
  end

  private

  attr_reader :contact
  delegate :last_activity_at, to: :contact

  def hot?
    last_activity_at > 24.hours.ago
  end

  def warm?
    last_activity_at > 7.days.ago
  end
end
