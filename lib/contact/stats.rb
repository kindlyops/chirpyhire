require_dependency 'contact/zipcode'

class Contact::Stats < Contact::Attribute
  def label
    "#{Contact::Certification.new(contact)} · "\
    "#{Contact::Experience.new(contact)} · "\
    "#{Contact::Zipcode.new(contact)}"\
    " · #{Contact::Availability.new(contact)}"\
    "#{Contact::LiveIn.new(contact).stat}"
  end
end
