class Engage::Manual::Messages::SentController < ApplicationController
  def index
    @messages = policy_scope(ManualMessage)
  end
end
