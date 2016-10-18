class GeoJson::Zipcode
  MAPPING_FILE = 'lib/geo_json_data/state_to_zipcode_mapping.json'.freeze
  def initialize(candidates)
    # include here
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

  attr_reader :candidates, :zipcode_mapping
  attr_accessor :zipcode_json_by_state

  def build_feature_for_stage_zipcode_group(stage_zipcode_group)
    key = stage_zipcode_group[0]
    scoped_candidates = stage_zipcode_group[1]
    stage = key[0]
    zipcode = key[1]

    state = state_for(zipcode)
    state_json = state_json(state)
    feature = find_zipcode_feature(state_json, zipcode)
    {
      properties:
      {
        stage_name: stage.name,
        description: description(scoped_candidates),
        zipcode: feature["properties"]["ZCTA5CE10"],
        center: feature["geometry"]["center"]
      },
      geometry: feature["geometry"],
      type: GeoJson::FEATURE_TYPE
    }
  end

  def find_zipcode_feature(state_json, zipcode)
    feature = state_json['features'].detect do |f|
      f['properties']['ZCTA5CE10'] == zipcode
    end
    Logging::Logger.log("Zipcode #{zipcode} data not found") if feature.blank?
    feature
  end

  def description(candidates)
    return single_description(candidates[0]) if candidates.count == 1
    candidates.map(&:nickname).join("\n")
  end

  def single_description(candidate)
    location = "<p>Zipcode: #{candidate.zipcode}</p>"
    GeoJson.single_description(candidate, candidate_location_p_tag: location)
  end

  def state_json(state)
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
