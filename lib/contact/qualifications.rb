class Contact::Qualifications < Contact::Attribute
  def qualifications
    [
      Contact::Certification.new(contact),
      Contact::SkinTest.new(contact),
      Contact::CprFirstAid.new(contact)
    ]
  end

  delegate :each, to: :qualifications
end
