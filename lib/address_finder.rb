class AddressFinder
  NAIVE_ADDRESS_REGEXP = /.+\d{5,}.*/m

  def initialize(text)
    @text = text
  end

  delegate :address, :latitude, :longitude, :country, :country_code,
  :city, :state, :state_code, :postal_code, to: :result

  def found?
    return unless text.present?
    naive_match? && result.present?
  end

  def naive_match?
    return unless text.present?
    text.scan(NAIVE_ADDRESS_REGEXP).present?
  end

  alias :full_street_address :address

  def self.client=(client)
    @client = client
  end

  def self.client
    @client
  end

  private

  attr_reader :text

  def result
    @result ||= results.first
  end

  def client
    self.class.client
  end

  def results
    @results ||= client.search(text, params).sort {|r1, r2| r2.data["confidence"] <=> r1.data["confidence"] }
  end

  def params
    { params: { countrycode: 'us', min_confidence: 8, no_annotations: 1 } }
  end
end

