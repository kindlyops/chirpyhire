class Engage::BotsController < ApplicationController
  layout 'react'

  def index
    @bots = policy_scope(Bot)

    respond_to do |format|
      format.json
    end
  end

  def show
    @bot = authorize(bots.find(params[:id]))

    respond_to do |format|
      format.json
      format.html { render html: '', layout: true }
    end
  end

  delegate :bots, to: :current_organization
end
