class Candidacy::Screened < Candidacy::Attribute
  def initialize(candidacy, organization)
    @candidacy = candidacy
    @organization = organization
  end

  attr_reader :organization

  def label
    return 'Screened' if candidacy.screened_at(organization)
    'Unscreened'
  end
end
