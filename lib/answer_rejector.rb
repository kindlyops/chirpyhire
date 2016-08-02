class AnswerRejector

  def initialize(candidate, question)
    @candidate = candidate
    @question = question
  end

  def call
    return false unless question.has_geofence?
    too_far?(question.distance_in_miles, candidate.address.coordinates, question.coordinates)
  end

  private

  attr_reader :candidate, :question

  def too_far?(distance, point1, point2)
    Geocoder::Calculations.distance_between(point1, point2) > distance
  end
end
