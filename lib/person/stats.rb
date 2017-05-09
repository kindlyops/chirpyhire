require_dependency 'person/zip_code'

class Person::Stats < Person::Attribute
  def label
    "#{Person::Certification.new(person)} · "\
    "#{Person::Experience.new(person)} · "\
    "#{Person::ZipCode.new(person)}"\
    " · #{Person::Availability.new(person)}"
  end
end
