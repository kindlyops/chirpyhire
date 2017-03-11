class Organizations::Settings::ProfilesController < ApplicationController
  def show
    @profile = authorize(current_organization)
  end

  def update
    @profile = authorize(current_organization)
    if @profile.update(permitted_attributes(Organization))
      redirect_to organizations_settings_profile_path, notice: 'Profile updated!'
    else
      render :show
    end
  end
end
