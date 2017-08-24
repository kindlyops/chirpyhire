class Settings::Candidate::StagesController < ApplicationController
  skip_after_action :verify_authorized, only: :reorder

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

  def reorder
    if organization.update!(contact_stages_attributes: stages_attributes)
      redirect_to contact_stage_settings
    else
      @contact_stages = policy_scope(organization.contact_stages)
      render :index
    end
  end

  def destroy
    ContactStage.transaction do
      contact_stage.goals.with_deleted.find_each do |goal|
        goal.update(contact_stage: nil)
      end

      contact_stage.contacts.find_each do |contact|
        contact.update(stage: migrate_stage)
      end

      contact_stage.destroy
    end

    redirect_to contact_stage_settings, notice: destroy_notice
  end

  private

  def stages_attributes
    params[:ordered_contact_stages].map.with_index do |id, new_rank|
      { id: id, rank: new_rank }
    end
  end

  def migrate_stage
    @migrate_stage ||= begin
      authorize(contact_stages.find(params[:migrate_stage_id]), :show?)
    end
  end

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
