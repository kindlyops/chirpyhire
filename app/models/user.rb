class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
end
