class Notice < ActiveRecord::Base
  belongs_to :template
  has_many :notifications
  has_many :actions, as: :actionable
end
