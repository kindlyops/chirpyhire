class Team < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization
  belongs_to :recruiter, class_name: 'Account'

  has_one :recruiting_ad
  has_one :location

  validates_associated :location
  validates :location, presence: true

  has_many :memberships
  has_many :accounts, through: :memberships
end
