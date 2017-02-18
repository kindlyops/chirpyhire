class Dashboard

  def initialize(organization)
    @organization = organization
  end

  def candidates
    organization.candidates
  end

  attr_reader :organization

end
