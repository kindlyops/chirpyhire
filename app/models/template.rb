class Template < ActiveRecord::Base
  belongs_to :organization
  has_one :notice
end
