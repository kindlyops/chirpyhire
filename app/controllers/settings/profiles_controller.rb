class Settings::ProfilesController < ApplicationController
  def show
    @profile = authorize(current_account)
  end
end
