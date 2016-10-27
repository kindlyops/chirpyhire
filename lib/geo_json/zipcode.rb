require 'uri'
class GeoJson::Zipcode
  def initialize(candidates, state_data)
    @candidates = candidates.select { |c| c.zipcode.present? }.compact
    @state_data = state_data
  end

  def features
    stage_zipcode_groups = candidates
                           .group_by { |c| [c.stage, c.zipcode] }

    stage_zipcode_groups
      .map(&method(:build_feature_for_stage_zipcode_group))
      .flatten
      .compact
  end

  class DataNotFoundError < StandardError
  end

  private

  attr_reader :candidates, :state_data

  def build_feature_for_stage_zipcode_group(stage_zipcode_group)
    scoped_candidates = stage_zipcode_group[1]
    stage = stage_zipcode_group[0][0]
    zipcode = stage_zipcode_group[0][1]

    state_json = state_data.state_json(zipcode)
    feature = find_zipcode_feature(state_json, zipcode)
    properties = feature_properties(stage, zipcode, scoped_candidates, feature)

    build_zipcode_feature(properties, feature)
  rescue DataNotFoundError => e
    Logging::Logger.log(e.message)
    return nil
  end

  def build_zipcode_feature(properties, feature)
    {
      properties: properties,
      geometry: feature['geometry'],
      type: GeoJson::FEATURE_TYPE
    }
  end

  def feature_properties(stage, zipcode, scoped_candidates, feature)
    {
      stage_name: stage.name,
      description: description(stage, zipcode, scoped_candidates),
      zipcode: zipcode,
      center: feature['geometry']['center']
    }
  end

  def find_zipcode_feature(state_json, zipcode)
    feature = state_json['features'].detect do |f|
      f['properties']['ZCTA5CE10'] == zipcode
    end
    raise DataNotFoundError, "Zipcode #{zipcode}" if feature.blank?
    feature
  end

  def description(stage, zipcode, candidates)
    return single_description(candidates[0]) if candidates.count == 1
    "<h3>Zipcode: <a href='/candidates?" \
      "zipcode=#{zipcode}" \
      "&stage_name=#{URI.encode(stage.name)}" \
      "&created_in=#{URI.encode(Candidate::CREATED_IN_OPTIONS[:ALL_TIME])}'>" \
      "#{zipcode}</a></h3>" \
    "<p class='handle sub-header'>#{candidates.count} candidates</p>"
  end

  def single_description(candidate)
    location = "<p>Zipcode: #{candidate.zipcode}</p>"
    GeoJson.single_description(candidate, candidate_location_p_tag: location)
  end
end
