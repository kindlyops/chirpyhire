class SubscriptionPlan < ApplicationRecord
  include Payola::Plan

  def redirect_path(subscription)
    # you can return any path here, possibly referencing the given subscription
    '/'
  end
end
