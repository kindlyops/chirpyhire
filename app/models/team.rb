class Team < ApplicationRecord
  belongs_to :organization
  belongs_to :recruiter, class_name: 'Account'

  has_one :recruiting_ad
  has_one :location

  has_many :memberships
  has_many :accounts, through: :memberships

  has_one :location
  has_one :inbox
  has_many :conversations, through: :inbox

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

  def phone_number
    return unless inbox && inbox.assignment_rules.present?
    inbox.assignment_rules.first.phone_number.phone_number
  end
end
