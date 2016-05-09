class TriggersController < ApplicationController
  def index
    @triggers = triggers
  end

  private

  def triggers
    organization.triggers
  end
end
