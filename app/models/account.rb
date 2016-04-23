class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:admin, :owner]
  belongs_to :organization
  belongs_to :user
  has_many :searches

  delegate :first_name, :last_name, :name, to: :user
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :organization
end
