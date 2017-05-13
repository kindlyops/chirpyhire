require_dependency 'contact/zip_code'

class Contact::Stats < Contact::Attribute
  def label
    "#{Contact::Certification.new(contact)} · "\
    "#{Contact::Experience.new(contact)} · "\
    "#{Contact::ZipCode.new(contact)}"\
    " · #{Contact::Availability.new(contact)}"\
    "#{Contact::LiveIn.new(contact).stat}"
  end
end
