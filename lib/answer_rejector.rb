class AnswerRejector

  def initialize(candidate, persona_feature, answer)
    @candidate = candidate
    @persona_feature = persona_feature
    @answer = answer
  end

  def call
    return unless persona_feature.has_geofence?
    too_far?(persona_feature.distance_in_miles, candidate.address.coordinates, persona_feature.coordinates)
  end

  private

  attr_reader :candidate, :persona_feature, :answer

  def too_far?(distance, point1, point2)
    Geocoder::Calculations.distance_between(point1, point2) > distance
  end
end
