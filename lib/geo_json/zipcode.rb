require 'uri'
class GeoJson::Zipcode
  def initialize(candidates)
    @candidates = candidates.select { |c| c.zipcode.present? }.compact
  end

  def features
    stage_zipcode_groups = candidates
                           .group_by { |c| [c.stage, c.zipcode] }

    stage_zipcode_groups
      .map(&method(:build_feature_for_stage_zipcode_group))
      .flatten
      .compact
  end

  private

  attr_reader :candidates

  def build_feature_for_stage_zipcode_group(stage_zipcode_group)
    scoped_candidates = stage_zipcode_group[1]
    stage = stage_zipcode_group[0][0]
    zipcode = stage_zipcode_group[0][1]

    properties = feature_properties(stage, zipcode, scoped_candidates)

    build_zipcode_feature(properties)
  end

  def build_zipcode_feature(properties)
    {
      properties: properties,
      type: GeoJson::FEATURE_TYPE
    }
  end

  def feature_properties(stage, zipcode, scoped_candidates)
    {
      stage_name: stage.name,
      description: description(stage, zipcode, scoped_candidates),
      zipcode: zipcode,
    }
  end

  def description(stage, zipcode, candidates)
    return single_description(candidates[0]) if candidates.count == 1
    created_in = URI.encode(CandidateFilterable::CREATED_IN_OPTIONS[:ALL_TIME])
    "<h3>Zipcode: <a href='/candidates?" \
      "zipcode=#{zipcode}" \
      "&stage_name=#{URI.encode(stage.name)}" \
      "&created_in=#{created_in}'>" \
      "#{zipcode}</a></h3>" \
    "<p class='handle sub-header'>#{candidates.count} candidates</p>"
  end

  def single_description(candidate)
    location = "<p>Zipcode: #{candidate.zipcode}</p>"
    GeoJson.single_description(candidate, candidate_location_p_tag: location)
  end
end
