class Industry < ActiveRecord::Base
  has_many :organizations
  has_many :questions
end
