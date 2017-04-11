class Zipcode < ApplicationRecord
  has_many :people

  alias_attribute :to_s, :zipcode
end
