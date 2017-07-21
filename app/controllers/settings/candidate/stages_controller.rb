class Settings::Candidate::StagesController < ApplicationController
  def index
    @contact_stages = policy_scope(organization.contact_stages)
  end

  def update
    if contact_stage.update(permitted_attributes(ContactStage))
      redirect_to contact_stage_settings, notice: success_notice
    else
      render :index
    end
  end

  private

  def contact_stage_settings
    organization_settings_contact_stages_path(organization)
  end

  def success_notice
    "Updated #{contact_stage.name} stage"
  end

  def contact_stage
    @contact_stage ||= authorize(contact_stages.find(params[:id]))
  end

  def contact_stages
    @contact_stages ||= policy_scope(organization.contact_stages)
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
