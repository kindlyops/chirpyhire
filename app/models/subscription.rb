class Subscription < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :candidate

end
