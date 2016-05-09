class Rule < ActiveRecord::Base
  belongs_to :automation
  enum status: [:enabled, :disabled]
end
