class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidate
  has_one :referrer
  has_one :account
  belongs_to :organization

  delegate :name, to: :organization, prefix: true
  delegate :owner_first_name, to: :organization
  accepts_nested_attributes_for :organization

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number
    super || ""
  end
end
