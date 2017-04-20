class Caregiver::Qualifications < Caregiver::Attribute
  def qualifications
    [
      Caregiver::Certification.new(contact),
      Caregiver::SkinTest.new(contact),
      Caregiver::CprFirstAid.new(contact)
    ]
  end

  delegate :each, to: :qualifications
end
