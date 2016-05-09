class Rule < ActiveRecord::Base
  belongs_to :automation
  has_one :trigger
  enum status: [:enabled, :disabled]
end
