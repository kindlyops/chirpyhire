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
    feature['properties']['stage_name'] = stage.name
    feature['properties']['description'] = description(scoped_candidates)
    feature
  end

  def find_zipcode_feature(state_json, zipcode)
    feature = state_json['features'].detect do |f|
      f['properties']['ZCTA5CE10'] == zipcode
    end
    Logging::Logger.log("Zipcode #{zipcode} data not found") if feature.blank?
    feature
  end

  def description(candidates)
    candidates.map(&:nickname).join("\n")
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
