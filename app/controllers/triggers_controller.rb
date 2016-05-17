class TriggersController < ApplicationController
  def index
    @triggers = TriggersPresenter.new(triggers)
  end

  private

  def triggers
    organization.triggers
  end
end
