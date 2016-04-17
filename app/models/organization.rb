class Organization < ActiveRecord::Base
  has_many :accounts
  has_many :phones
  has_many :leads
  has_many :team_members
end
