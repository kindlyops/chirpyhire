class Caregiver::Stats < Caregiver::Attribute
  def label
    "#{Caregiver::Certification.new(contact)} · "\
    "#{Caregiver::Experience.new(contact)} · "\
    "#{Caregiver::Zipcode.new(contact)}"\
    " · #{Caregiver::Availability.new(contact)}"
  end
end
