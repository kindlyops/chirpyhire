class Account < ApplicationRecord
  devise :invitable, :rememberable, :database_authenticatable,
         :registerable, :recoverable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization, inverse_of: :accounts
  belongs_to :person

  has_many :notes
  has_many :ahoy_messages, class_name: 'Ahoy::Message', as: :user
  has_many :memberships
  has_many :manual_messages
  has_many :teams, through: :memberships
  has_many :inboxes, through: :teams
  has_many :conversations, through: :inboxes
  has_many :segments
  has_many :imports

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  accepts_nested_attributes_for :organization, reject_if: :all_blank

  validates :email, uniqueness: true
  delegate :name, to: :organization, prefix: true
  before_validation :add_nickname
  validates :name, presence: true, unless: :nickname_present?
  validates :nickname, presence: true, unless: :name_present?

  enum role: {
    member: 0, owner: 1, invited: 2
  }

  def self.daily_email
    where(daily_email: true)
  end

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
    return name if name.present?

    nickname
  end

  private

  def add_nickname
    return if name.present? || nickname.present?
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end

  def nickname_present?
    nickname.present?
  end

  def name_present?
    name.present?
  end
end
