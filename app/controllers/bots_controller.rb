class BotsController < ApplicationController
  def index
    @bots = policy_scope(Bot)

    respond_to do |format|
      format.json
    end
  end
end
