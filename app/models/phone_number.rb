class PhoneNumber < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  phony_normalize :forwarding_phone_number, default_country_code: 'US'

  belongs_to :organization
  has_one :assignment_rule
  has_many :conversations

  def self.not_forwarding
    where(forwarding_phone_number: nil)
  end
end
