class Team < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization
  belongs_to :recruiter, class_name: 'Account'

  has_one :recruiting_ad
  has_one :location

  has_many :memberships
  has_many :accounts, through: :memberships
  has_many :contacts
end
