class AddressFinder
  cattr_accessor :client
  NAIVE_ADDRESS_REGEXP = /.+\d{5,}.*/m

  def initialize(text)
    @text = text
    @error_message = nil
  end

  delegate :address, :latitude, :longitude, :country, :country_code,
           :city, :postal_code, to: :result

  def found?
    naive_match? && result.present? && postal_code_found?
  end

  def postal_code_found?
    result.postal_code.present? && text.include?(result.postal_code)
  end

  def naive_match?
    return unless text.present?
    text.scan(NAIVE_ADDRESS_REGEXP).present?
  end

  alias full_street_address address

  def state
    STATE_MAPPING[result.state.downcase] || result.state
  end

  alias state_code state

  attr_accessor :error_message

  private

  attr_reader :text

  def result
    @result ||= results.first
  end

  def client
    self.class.client
  end

  def results
    @results ||= client.search(text, params).sort do |r1, r2|
      r2.data['confidence'] <=> r1.data['confidence']
    end
  end

  def params
    { params: { countrycode: 'us', min_confidence: 8, no_annotations: 1 } }
  end

  STATE_MAPPING = {
    'alabama' => 'AL',
    'alaska' => 'AK',
    'arkansas' => 'AR',
    'california' => 'CA',
    'colorado' => 'CO',
    'connecticut' => 'CT',
    'delaware' => 'DE',
    'florida' => 'FL',
    'georgia' => 'GA',
    'hawaii' => 'HI',
    'idaho' => 'ID',
    'illinois' => 'IL',
    'indiana' => 'IN',
    'iowa' => 'IA',
    'kansas' => 'KS',
    'kentucky' => 'KY',
    'louisiana' => 'LA',
    'maine' => 'ME',
    'maryland' => 'MD',
    'massachusetts' => 'MA',
    'michigan' => 'MI',
    'minnesota' => 'MN',
    'mississippi' => 'MS',
    'missouri' => 'MO',
    'montana' => 'MT',
    'nebraska' => 'NE',
    'nevada' => 'NV',
    'new hampshire' => 'NH',
    'new jersey' => 'NJ',
    'new mexico' => 'NM',
    'new york' => 'NY',
    'north carolina' => 'NC',
    'north dakota' => 'ND',
    'ohio' => 'OH',
    'oklahoma' => 'OK',
    'oregon' => 'OR',
    'pennsylvania' => 'PA',
    'rhode island' => 'RI',
    'south carolina' => 'SC',
    'south dakota' => 'SD',
    'tennessee' => 'TN',
    'texas' => 'TX',
    'utah' => 'UT',
    'vermont' => 'VT',
    'virginia' => 'VA',
    'washington' => 'WA',
    'west virginia' => 'WV',
    'wisconsin' => 'WI',
    'wyoming' => 'WY'
  }.freeze
end
