class Bot < ApplicationRecord
  belongs_to :organization
  belongs_to :last_edited_by, optional: true, class_name: 'Account'

  has_one :greeting
  has_many :questions
  has_many :goals
end
