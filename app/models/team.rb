class Team < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization
  belongs_to :recruiter, class_name: 'Account'

  has_one :recruiting_ad
  has_one :location

  has_many :memberships
  has_many :accounts, through: :memberships
  has_many :contacts
  has_many :inbox_conversations, through: :accounts

  has_one :location
  validates_associated :location
  validates :location, presence: true
  accepts_nested_attributes_for :location,
                                reject_if: ->(l) { l.values.any?(&:blank?) }

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  validates :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  delegate :name, to: :organization, prefix: true
  delegate :zipcode, to: :location

  def promote(account)
    return unless account.organization == organization
    accounts << account unless account.on?(self)
    memberships.find_by(account: account).update(role: :manager)
  end
end
