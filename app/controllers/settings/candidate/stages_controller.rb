class Settings::Candidate::StagesController < ApplicationController
  def index
    @contact_stages = policy_scope(organization.contact_stages)
  end

  def update
    if contact_stage.update(permitted_attributes(ContactStage))
      redirect_to contact_stage_settings, notice: update_notice
    else
      render :index
    end
  end

  def create
    @contact_stage = contact_stages.create(permitted_attributes(ContactStage))

    if @contact_stage.valid?
      redirect_to contact_stage_settings, notice: create_notice
    else
      render :index
    end
  end

  def destroy
    if contact_stage.destroy
      redirect_to contact_stage_settings, notice: destroy_notice
    else
      render :index
    end
  end

  private

  def contact_stage_settings
    organization_settings_candidate_stages_path(organization)
  end

  def destroy_notice
    "Deleted #{contact_stage.name} stage"
  end

  def update_notice
    "Updated #{contact_stage.name} stage"
  end

  def create_notice
    "Created #{contact_stage.name} stage"
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
