class Automation < ActiveRecord::Base
  belongs_to :organization
  has_many :rules
end
