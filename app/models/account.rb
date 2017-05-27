class Account < ApplicationRecord
  devise :invitable, :rememberable, :database_authenticatable,
         :registerable, :recoverable, :trackable, :validatable

  belongs_to :organization, inverse_of: :accounts
  belongs_to :person, inverse_of: :account

  has_many :inbox_conversations
  has_many :notes
  has_many :ahoy_messages, class_name: 'Ahoy::Message', as: :user
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :contacts, through: :teams
  has_one :inbox

  accepts_nested_attributes_for :organization, reject_if: :all_blank
  accepts_nested_attributes_for :person, reject_if: :all_blank

  validates :email, uniqueness: true

  delegate :name, to: :organization, prefix: true
  delegate :name, :avatar, :handle, to: :person, allow_nil: true

  enum role: {
    member: 0, owner: 1, invited: 2
  }

  def on?(team)
    memberships.where(team: team).exists?
  end

  def manages?(team)
    on?(team) && memberships.find_by(team: team).manager?
  end

  def phone_numbers
    teams.pluck(:phone_number).compact
  end

  def self.active
    where(invitation_token: nil)
  end

  def first_name
    return unless name.present?
    name.split(' ', 2).first
  end

  def send_reset_password_instructions
    super if invitation_token.nil?
  end
end
