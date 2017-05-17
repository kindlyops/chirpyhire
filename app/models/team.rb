class Team < ApplicationRecord
  belongs_to :organization
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :memberships
  has_many :accounts, through: :memberships

  has_many :contacts
  has_one :recruiting_ad
  belongs_to :recruiter, class_name: 'Account'

  validates :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  has_one :location
  validates_associated :location
  validates :location, presence: true
  accepts_nested_attributes_for :location,
                                reject_if: ->(l) { l.values.any?(&:blank?) }

  delegate :zipcode, to: :location
end
