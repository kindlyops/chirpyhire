# frozen_string_literal: true
FactoryGirl.define do
  factory :location do
    latitude 33.929966
    longitude { -84.373931 }
    full_street_address Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    state_code Faker::Address.state_abbr
    postal_code Faker::Address.zip_code
    country 'United States of America'
    country_code 'us'
  end
end
