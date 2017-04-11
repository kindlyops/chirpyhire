class Contact::Stats < Contact::Attribute
  def label
    "#{Contact::Certification.new(contact)} · "\
    "#{Contact::Experience.new(contact)} · "\
    "#{Contact::CandidacyZipcode.new(contact)}"\
    " · #{Contact::Availability.new(contact)}"
  end
end
