class Account < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  accepts_nested_attributes_for :organization, reject_if: :all_blank

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates :email, uniqueness: true

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
