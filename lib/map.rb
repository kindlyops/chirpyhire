class Map

  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def center
    location = self.organization.location
    [location.longitude, location.latitude]
  end

  def zoom
    10
  end
end
