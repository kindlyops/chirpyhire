class CandidacyDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidacy

  def button_class(attribute)
    return 'btn-secondary' if object.send(attribute)

    'btn-outline-secondary'
  end

  def availability
    humanize_attribute(super) || 'Unknown'
  end

  def transportation
    humanize_attribute(super) || 'Unknown'
  end

  def experience
    humanize_attribute(super) || 'Unknown'
  end

  def location
    zipcode || 'Unknown'
  end

  def icon_class(attribute)
    if qualification_or_location?(attribute)
      object.send(attribute).present? && icon_classes[attribute]
    elsif certification?(attribute.to_sym)
      object.certification.present? && icon_classes[attribute]
    else
      icon_classes[object.send(attribute)] || 'fa-question'
    end
  end

  def qualification_or_location?(attribute)
    attribute == :skin_test ||
    attribute == :cpr_first_aid ||
    attribute == :location
  end

  def certification?(attribute)
    attribute == :cna ||
    attribute == :pca ||
    attribute == :other_certification ||
    attribute == :no_certification
  end

  def humanize_attribute(attribute)
    return unless attribute

    humanize_attributes[attribute]
  end

  def humanize_attributes
    {
      full_time: 'Full-Time',
      part_time: 'Part-Time',
      live_in: 'Live-In',
      flexible: 'Flexible',
      no_availability: 'None',
      personal_transportation: 'Personal',
      public_transportation: 'Public',
      no_transportation: 'None',
      pca: 'PCA',
      cna: 'CNA',
      other_certification: 'RN, LPN, Other',
      no_certification: 'None',
      less_than_one: 'Less than 1 year',
      one_to_five: '1 - 5 years',
      six_or_more: '6+ years',
      no_experience: 'None',
      skin_test: 'Skin / TB Test',
      cpr_first_aid: 'CPR / 1st Aid'
    }.with_indifferent_access
  end

  def icon_classes
    {
      full_time: 'fa-hourglass',
      part_time: 'fa-hourglass-end',
      live_in: 'fa-home',
      flexible: 'fa-hourglass-half',
      no_availability: 'fa-hourglass-o',
      personal_transportation: 'fa-car',
      public_transportation: 'fa-bus',
      no_transportation: 'fa-thumbs-o-up',
      pca: 'fa-heart-o',
      cna: 'fa-heart',
      other_certification: 'fa-heartbeat',
      no_certification: 'fa-graduation-cap',
      less_than_one: 'fa-battery-quarter',
      one_to_five: 'fa-battery-half',
      six_or_more: 'fa-battery-full',
      no_experience: 'fa-battery-empty',
      skin_test: 'fa-newspaper-o',
      cpr_first_aid: 'fa-medkit',
      location: 'fa-map-marker'
    }.with_indifferent_access
  end

  def qualifications
    [
      certification,
      skin_test_qualification,
      cpr_first_aid_qualification
    ].compact
  end

  def skin_test_qualification
    return :skin_test if skin_test.present?
  end

  def cpr_first_aid_qualification
    return :cpr_first_aid if cpr_first_aid.present?
  end
end
