class AddressFinder
  NAIVE_ADDRESS_REGEXP = /.+\d{5,}.*/m

  def initialize(text)
    @text = text
  end

  delegate :address, :latitude, :longitude, :country, :city, :postal_code, to: :result

  def found?
    naive_match? && result.present?
  end

  def naive_match?
    text.scan(NAIVE_ADDRESS_REGEXP).present?
  end

  private

  attr_reader :text

  def result
    @result ||= results.first
  end

  def results
    @results ||= Geocoder.search(text, params).sort {|r1, r2| r2.data["confidence"] <=> r1.data["confidence"] }
  end

  def params
    { params: { countrycode: 'us', min_confidence: 8, no_annotations: 1 } }
  end
end

