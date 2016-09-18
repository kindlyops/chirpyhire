class Plan < ApplicationRecord
  def self.messages_per_quantity
    @messages_per_quantity ||= 500
  end

  class << self
    attr_writer :messages_per_quantity
  end

  DEFAULT_QUANTITY = 2
  DEFAULT_PRICE_IN_DOLLARS = 50
  TRIAL_MESSAGE_LIMIT = 100
end
