class GeoJson::StateData
  MAPPING_FILE = 'lib/geo_json_data/state_to_zipcode_mapping.json'.freeze
  def initialize
    @zipcode_mapping = JSON.parse(File.read("#{Rails.root}/#{MAPPING_FILE}"))
  end

  def state_json(zipcode)
    state = state_for(zipcode)
    if state.blank?
      raise(GeoJson::Zipcode::DataNotFoundError, "No state for #{zipcode}")
    end

    state_data(state)
  end

  private

  attr_reader :zipcode_mapping

  def state_data(state)
    cached_data = Rails.cache.read(cache_key(state))
    return cached_data if cached_data.present?
    data = fetch_raw_data(state)
    parsed_data = JSON.parse(data)
    Rails.cache.write(cache_key(state), parsed_data)
    parsed_data
  end

  def fetch_raw_data(state)
    relative_file_path = "geo_json_data/#{state}.json"
    if Rails.env.development?
      File.read("#{Rails.root}/lib/#{relative_file_path}")
    else
      S3_BUCKET.object(relative_file_path).get.body.read
    end
  end

  def state_for(zipcode)
    zipcode_mapping[zipcode]
  end

  def cache_key(state)
    "state_data_#{state}"
  end
end
