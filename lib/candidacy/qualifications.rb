class Candidacy::Qualifications < Candidacy::Attribute
  def qualifications
    [
      Candidacy::Certification.new(candidacy),
      Candidacy::SkinTest.new(candidacy),
      Candidacy::CprFirstAid.new(candidacy)
    ]
  end

  delegate :each, to: :qualifications
end
