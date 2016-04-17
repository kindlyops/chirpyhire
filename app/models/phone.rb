class PhoneNumber < ActiveRecord::Base
  attr_readonly :number
  belongs_to :organization
end
