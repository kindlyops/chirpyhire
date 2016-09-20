class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :user

  delegate :first_name, :last_name, :name, :organization, to: :user
  delegate :survey, to: :organization
  accepts_nested_attributes_for :user

  def self.active
    where(invitation_token: nil)
  end

  def send_reset_password_instructions
    super if invitation_token.nil?
  end

  def self.accept_invitation!(attributes = {})
    original_token = attributes.delete(:invitation_token)
    invitable = find_by_invitation_token(original_token, false)
    if invitable.errors.empty?
      invitable.user.assign_attributes(attributes.delete(:user_attributes))
      invitable.assign_attributes(attributes)
      invitable.accept_invitation!
    end
    invitable
  end
end
