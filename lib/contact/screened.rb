class Contact::Screened < Contact::Attribute
  def label
    'Screened'
  end

  def to_s
    candidacy.cpr_first_aid.present?.to_s
  end

  def search_label
    label if contact.screened.present?
  end
end
