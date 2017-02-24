class Candidacy::Screened < Candidacy::Attribute
  def initialize(candidacy, organization)
    @candidacy = candidacy
    @organization = organization
  end

  attr_reader :organization

  def label
    candidacy.screened_at(organization)
  end
end
