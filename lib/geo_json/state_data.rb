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
      state_data = get_state_data(state)
      zipcode_json_by_state[state] = JSON.parse(state_data)
    end
    zipcode_json_by_state[state]
  end

  private

  attr_reader :zipcode_mapping
  attr_accessor :zipcode_json_by_state

  def get_state_data(state)
    if Rails.env.development?
      return File.read("#{Rails.root}/lib/geo_json_data/#{state}.json")
    end
    cached_data = Rails.cache.read(cache_key(state))
    return cached_data if cached_data.present?
    data = S3_BUCKET.object("geo_json_data/#{state}.json").get.body.read
    Rails.cache.write(cache_key(state), data)
    data
  end

  def state_for(zipcode)
    zipcode_mapping[zipcode]
  end

  def cache_key(state)
    "state_data_#{state}"
  end
end
