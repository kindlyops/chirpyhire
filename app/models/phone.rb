class Phone < ActiveRecord::Base
  belongs_to :organization

  attr_readonly :number
  phony_normalize :number, default_country_code: 'US'
end
