class Trigger < ActiveRecord::Base
  belongs_to :rule
  has_many :actions
end
