class Zipcode < ApplicationRecord
  has_many :people
  has_many :contacts
end
