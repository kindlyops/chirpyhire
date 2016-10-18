require 'uri'
class GeoJson::Zipcode
  MAPPING_FILE = 'lib/geo_json_data/state_to_zipcode_mapping.json'.freeze
  def initialize(candidates)
    @candidates = candidates.select { |c| c.zipcode.present? }.compact
    @zipcode_json_by_state = {}
    @zipcode_mapping = JSON.parse(File.read("#{Rails.root}/#{MAPPING_FILE}"))
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

  class DataNotFoundError < StandardError
  end

  attr_reader :candidates, :zipcode_mapping
  attr_accessor :zipcode_json_by_state

  def build_feature_for_stage_zipcode_group(stage_zipcode_group)
    key = stage_zipcode_group[0]
    scoped_candidates = stage_zipcode_group[1]
    stage = key[0]
    zipcode = key[1]

    state_json = state_json(zipcode)
    feature = find_zipcode_feature(state_json, zipcode)
    properties = feature_properties(stage, zipcode, scoped_candidates, feature)

    build_zipcode_feature(properties, feature)
  rescue DataNotFoundError => e
    Logging::Logger.log(e.message)
    return nil;
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
    raise DataNotFoundError, "Zipcode #{zipcode} data not found" if feature.blank?
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

  def state_json(zipcode)
    state = state_for(zipcode)
    raise DataNotFoundError, "State for #{zipcode} not found" if state.blank?

    unless zipcode_json_by_state.key?(state)
      state_data = File.read("#{Rails.root}/lib/geo_json_data/#{state}.json")
      zipcode_json_by_state[state] = JSON.parse(state_data)
    end
    zipcode_json_by_state[state]
  end

  def state_for(zipcode)
    zipcode_mapping[zipcode]
  end
end
