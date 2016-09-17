# frozen_string_literal: true
class Map
  def initialize(organization)
    @organization = organization
  end

  def center
    [location.longitude, location.latitude]
  end

  def zoom
    10
  end

  private

  attr_reader :organization

  def location
    organization.location
  end
end
