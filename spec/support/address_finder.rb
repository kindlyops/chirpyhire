class FakeGeocoder
  Result = Struct.new(:data) do
    def address
      data['formatted']
    end

    def latitude
      data['geometry']['lat']
    end

    def longitude
      data['geometry']['lng']
    end

    def city
      data['components']['city']
    end

    def country
      data['components']['country']
    end

    def state
      data['components']['state']
    end

    def country_code
      data['components']['country_code']
    end

    def state_code
      data['components']['state']
    end

    def postal_code
      data['components']['postcode']
    end
  end

  def self.search(*)
    [Result.new('bounds' => { 'northeast' => { 'lat' => 38.032225, 'lng' => -78.4811563 }, 'southwest' => { 'lat' => 38.0315186, 'lng' => -78.4830319 } },
                'components' =>
         { '_type' => 'road',
           'city' => 'Charlottesville',
           'country' => 'United States of America',
           'country_code' => 'us',
           'hamlet' => 'Vinegar Hill',
           'postcode' => '22902',
           'road' => 'Market Street',
           'state' => 'CA' },
                'confidence' => 10,
                'formatted' => 'Market Street, Charlottesville, VA 22902, United States of America',
                'geometry' => { 'lat' => 37.870842, 'lng' => -122.501366 })]
  end
end

RSpec.configure do |config|
  config.before(type: :feature) do
    AddressFinder.client = FakeGeocoder
  end

  config.after(type: :feature) do
    AddressFinder.client = Geocoder
  end
end
