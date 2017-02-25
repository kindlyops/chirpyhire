class Contact::Screened < Contact::Attribute
  def label
    contact.screened?
  end

  def search_label
    return 'Screened' if contact.screened.present?
  end
end
