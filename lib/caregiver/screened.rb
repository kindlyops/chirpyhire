class Caregiver::Screened < Caregiver::Attribute
  def label
    'Screened'
  end

  delegate :to_s, to: :value

  def value
    contact.screened.present?
  end

  def search_label
    label if contact.screened.present?
  end
end
