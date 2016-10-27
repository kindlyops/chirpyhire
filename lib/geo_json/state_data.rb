class GeoJson::StateData
  MAPPING_FILE = 'lib/geo_json_data/state_to_zipcode_mapping.json'.freeze
  def initialize
    @zipcode_json_by_state = {}
    @zipcode_mapping = JSON.parse(File.read("#{Rails.root}/#{MAPPING_FILE}"))
  end

  def state_json(zipcode)
    state = state_for(zipcode)
    if state.blank?
      raise(GeoJson::Zipcode::DataNotFoundError, "No state for #{zipcode}")
    end

    unless zipcode_json_by_state.key?(state)
      state_data = File.read("#{Rails.root}/lib/geo_json_data/#{state}.json")
      zipcode_json_by_state[state] = JSON.parse(state_data)
    end
    zipcode_json_by_state[state]
  end

  private

  attr_reader :zipcode_mapping
  attr_accessor :zipcode_json_by_state

  def state_for(zipcode)
    zipcode_mapping[zipcode]
  end
end
