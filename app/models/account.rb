class Account < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  accepts_nested_attributes_for :organization, reject_if: :all_blank
  has_one :user

  validates :email, uniqueness: true

  def self.active
    where(invitation_token: nil)
  end

  def send_reset_password_instructions
    super if invitation_token.nil?
  end
end
