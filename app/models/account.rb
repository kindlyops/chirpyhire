class Account < ApplicationRecord
  devise :invitable, :rememberable, :database_authenticatable,
         :registerable, :recoverable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization, inverse_of: :accounts
  has_one :person, inverse_of: :account

  has_many :notes
  has_many :ahoy_messages, class_name: 'Ahoy::Message', as: :user
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :inboxes, through: :teams
  has_many :conversations, through: :inboxes
  has_many :segments
  has_many :imports

  before_validation { build_person if person.blank? }

  accepts_nested_attributes_for :organization, reject_if: :all_blank
  accepts_nested_attributes_for :person, reject_if: :all_blank

  validates :email, uniqueness: true, company_email: true
  delegate :name, to: :organization, prefix: true
  delegate :name, :avatar, :nickname, to: :person, allow_nil: true

  before_validation { build_person if person.blank? }

  enum role: {
    member: 0, owner: 1, invited: 2
  }

  def self.not_on(team)
    where.not(id: team.memberships.pluck(:account_id))
  end

  def on?(team)
    memberships.where(team: team).exists?
  end

  def unread_count
    inboxes.map(&:unread_count).reduce(:+) || 0
  end

  def phone_numbers
    teams.pluck(:phone_number).compact
  end

  def self.active
    where(invitation_token: nil)
  end

  def first_name
    return if name.blank?
    name.split(' ', 2).first
  end

  def send_reset_password_instructions
    super if invitation_token.nil?
  end

  def handle
    name || email
  end
end
