class PhoneNumber < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  alias_attribute :to_s, :phone_number
end
