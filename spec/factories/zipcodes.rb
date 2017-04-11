FactoryGirl.define do
  factory :zipcode do
    zipcode { '30342' }
    zipcode_type { 'S' }
    default_city { 'Atlanta' }
    county_fips { '13121' }
    county_name { 'Fulton' }
    state_abbreviation { 'GA' }
    state { 'Georgia' }
    latitude { 33.89025 }
    longitude { -84.37299 }
    precision { 'Zip5' }    
  end
end
