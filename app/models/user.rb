class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :leads
  has_many :referrers
end
