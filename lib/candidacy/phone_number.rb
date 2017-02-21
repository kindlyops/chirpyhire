class Candidacy::PhoneNumber < Candidacy::Attribute
  def label
    candidacy.phone_number.phony_formatted
  end

  def icon_class
    return 'fa-question' unless candidacy.phone_number.present?

    'fa-phone'
  end

  def button_class
    'btn-primary'
  end
end
