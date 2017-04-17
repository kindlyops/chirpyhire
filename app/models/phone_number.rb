class PhoneNumber < ApplicationRecord
  alias_attribute :to_s, :phone_number
end
