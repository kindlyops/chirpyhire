class Account < ApplicationRecord
  devise :invitable, :rememberable, :database_authenticatable,
         :registerable, :recoverable, :trackable, :validatable

  belongs_to :organization, inverse_of: :accounts
  belongs_to :person, inverse_of: :account

  has_many :conversations
  has_many :notes
  has_many :ahoy_messages, class_name: 'Ahoy::Message', as: :user
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :contacts, through: :teams

  accepts_nested_attributes_for :organization, reject_if: :all_blank
  accepts_nested_attributes_for :person, reject_if: :all_blank

  validates :email, uniqueness: true

  delegate :name, to: :organization, prefix: true
  delegate :name, :avatar, :handle, to: :person, allow_nil: true

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
