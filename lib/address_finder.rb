class AddressFinder

  def initialize(text)
    @text = text
  end

  delegate :address, :latitude, :longitude, :country, :city, to: :result

  def found?
    result && result.layer == "address"
  end

  def postal_code
    result.postal_code.gsub(/\D/,"")
  end

  private

  attr_reader :text

  def result
    @result ||= Geocoder.search(text).first
  end
end

