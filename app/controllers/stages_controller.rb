class StagesController < ApplicationController
  before_action :setup_stages

  def index
  end

  def create
    created_stage = current_organization
                    .stages
                    .create(permitted_attributes(Stage.new))
    @stage = authorize(created_stage)
    flash[:notice] = 'Nice! Stage created.' if @stage.errors.blank?
    render :index
  end

  def edit
    @stage = authorized_stage
  end

  def update
    @stage = authorized_stage
    if @stage.update(permitted_attributes(Stage))
      flash[:notice] = "Nice! Stage \"#{authorized_stage.name}\" updated."
      redirect_to stages_url
    else
      render :edit
    end
  end

  def reorder
    stage_ids = params[:stages].keys
    Stage.find(stage_ids).each { |stage| authorize stage }
    StageOrderer.new(current_organization.stages)
                .reorder(stage_ids)

    flash[:notice] = 'Nice! Stage order saved.'
    redirect_to stages_url
  end

  def destroy
    if authorize(Stage.find(params[:id])).destroy
      flash[:notice] = 'Nice! Stage deleted.'
    end
    redirect_to stages_url
  end

  private

  def authorized_stage
    authorize(Stage.find(params[:id]))
  end

  def setup_stages
    @stages = scoped_stages.decorate
    @stage = current_organization.stages.build
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
