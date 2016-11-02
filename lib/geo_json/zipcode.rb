require 'uri'
class GeoJson::Zipcode
  def initialize(candidates, state_data)
    @candidates = candidates.select { |c| c.zipcode.present? }.compact
    @state_data = state_data
  end

  def features
    stage_zipcode_groups = candidates
                           .group_by { |c| [c.stage, c.zipcode] }

    stage = candidates.first.stage
    # stage_zipcode_groups
    ["30002",
"30004",
"30005",
"30008",
"30012",
"30015",
"30021",
"30030",
"30033",
"30034",
"30035",
"30038",
"30039",
"30044",
"30058",
"30060",
"30062",
"30064",
"30066",
"30067",
"30076",
"30080",
"30083",
"30088",
"30093",
"30096",
"30102",
"30106",
"30122",
"30127",
"30134",
"30135",
"30141",
"30144",
"30180",
"30188",
"30213",
"30223",
"30228",
"30236",
"30252",
"30269",
"30291",
"30297",
"30310",
"30315",
"30318",
"30322",
"30327",
"30331",
"30341",
"30344",
"30349",
"30350",
"30507",
"32207",
"48306",
"84118",
"95476"].map { |zipcode| [[stage, zipcode], candidates] }
      .map(&method(:build_feature_for_stage_zipcode_group))
      .flatten
      .compact
  end

  def dumb(zipcode)
    read_zipcode_feature(zipcode)
  end

  class DataNotFoundError < StandardError
  end

  private

  attr_reader :candidates, :state_data

  def build_feature_for_stage_zipcode_group(stage_zipcode_group)
    scoped_candidates = stage_zipcode_group[1]
    stage = stage_zipcode_group[0][0]
    zipcode = stage_zipcode_group[0][1]

    feature = read_zipcode_feature(zipcode)
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

  def find_zipcode_feature(zipcode)
    Rails.cache.fetch(zipcode) do
      state_json = state_data.state_json(zipcode)

      feature = state_json['features'].detect do |f|
        f['properties']['ZCTA5CE10'] == zipcode
      end
      raise DataNotFoundError, "Zipcode #{zipcode}" if feature.blank?
      feature
    end
  end

  def read_zipcode_feature(zipcode)
    # JSON.parse(File.read("~/Development/chire/geo_json_pre_convert_to_zip/zipcodes/#{zipcode}.json"))
    File.open("/Users/johnwhelchel/Development/chire/geo_json_pre_convert_to_zip/zipcodes/#{zipcode}.json")
  rescue Exception => e
    puts "Fuck it #{e.message}"
    raise DataNotFoundError, "shit"
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
