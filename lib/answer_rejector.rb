class AnswerRejector

  def initialize(candidate, persona_feature)
    @candidate = candidate
    @persona_feature = persona_feature
  end

  def call
    return false unless persona_feature.has_geofence?
    too_far?(persona_feature.distance_in_miles, candidate.address.coordinates, persona_feature.coordinates)
  end

  private

  attr_reader :candidate, :persona_feature

  def too_far?(distance, point1, point2)
    Geocoder::Calculations.distance_between(point1, point2) > distance
  end
end
