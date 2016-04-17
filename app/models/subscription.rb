class Subscription < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :lead
end
