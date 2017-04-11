require 'smartystreets_ruby_sdk/static_credentials'
require 'smartystreets_ruby_sdk/us_zipcode/client_builder'
require 'smartystreets_ruby_sdk/us_zipcode/lookup'

class ZipcodeFetcher
  def self.call(person, zipcode_string)
    new(person, zipcode_string).call
  end

  attr_reader :person, :zipcode_string

  def initialize(person, zipcode_string)
    @person = person
    @zipcode_string = zipcode_string
  end

  def call
    existing_zipcode = Zipcode.find_by(zipcode: zipcode_string)

    if existing_zipcode.present?
      person.update!(zipcode: existing_zipcode)
    else
      lookup.zipcode = zipcode_string
      client.send_lookup(lookup)

      person.update!(zipcode: created_zipcode)
    end
  end

  private

  def created_zipcode
    @created_zipcode ||= begin
      Zipcode.create!(response_zipcode.attributes.slice(zipcode_attributes))
    end
  end

  def zipcode_attributes
    %i(zipcode zipcode_type default_city county_fips county_name
       state_abbreviation state latitude longitude precision)
  end

  def response_zipcode
    @response_zipcode ||= result.zipcodes.first
  end

  def result
    @result ||= lookup.result
  end

  def lookup
    @lookup ||= USZipcode::Lookup.new
  end

  def auth_id
    ENV.fetch('SMARTY_AUTH_ID')
  end

  def auth_token
    ENV.fetch('SMARTY_AUTH_TOKEN')
  end

  def credentials
    StaticCredentials.new(auth_id, auth_token)
  end

  def client
    @client ||= USZipcode::ClientBuilder.new(credentials).build
  end
end
