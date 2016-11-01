class GeoJson::StateData
  MAPPING_FILE = 'lib/geo_json_data/state_to_zipcode_mapping.json'.freeze
  def initialize
    @zipcode_mapping = JSON.parse(File.read("#{Rails.root}/#{MAPPING_FILE}"))
    @state_jsons = {}
  end

  def state_json(zipcode)
    state = state_for(zipcode)
    if state.blank?
      raise(GeoJson::Zipcode::DataNotFoundError, "No state for #{zipcode}")
    end

    state_jsons[state] || build_state_json(state)
  end

  private

  attr_accessor :state_jsons

  attr_reader :zipcode_mapping

  def build_state_json(state)
    data = fetch_raw_data(state)
    state_jsons[state] = JSON.parse(data)
    state_jsons[state]
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
end
