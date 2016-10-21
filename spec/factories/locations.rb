FactoryGirl.define do
  factory :location do
    state_code = Faker::Address.state_abbr
    
    latitude 33.929966
    longitude { -84.373931 }
    full_street_address Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    state_code state_code
    postal_code Faker::Address.zip_code(state_code)
    country 'United States of America'
    country_code 'us'
  end
end
