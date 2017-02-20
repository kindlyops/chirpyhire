class SubscribersController < ApplicationController
  def index
    @subscribers = policy_scope(Subscriber)
  end
end
