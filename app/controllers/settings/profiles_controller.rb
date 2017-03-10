class Settings::ProfilesController < ApplicationController
  def show
    @profile = authorize(current_account)
  end

  def update
    @profile = authorize(current_account)
    if @profile.update(permitted_attributes(Account))
      redirect_to settings_profile_path, notice: 'Profile updated!'
    else
      render :show
    end
  end
end
