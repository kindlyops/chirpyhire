class Notice < ActiveRecord::Base
  belongs_to :template
  has_many :notifications
end
