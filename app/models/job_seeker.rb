class JobSeeker < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
end
