class Organizations::Settings::ProfilesController < ApplicationController
  def show
    @profile = authorize(current_organization)
  end

  def update
    @profile = authorize(current_organization)
    if @profile.update(permitted_attributes(Organization))
      redirect_to organizations_settings_profile_path, notice: update_notice
    else
      render :show
    end
  end

  private

  def update_notice
    'Profile updated!'
  end
end
