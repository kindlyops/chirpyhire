class SubscriptionPlan < ApplicationRecord
  DEFAULT_QUANTITY = 2
  DEFAULT_PRICE_IN_DOLLARS = 50
  MESSAGES_PER_QUANTITY = 500
  include Payola::Plan

  def redirect_path(subscription)
    # you can return any path here, possibly referencing the given subscription
    '/'
  end
end
