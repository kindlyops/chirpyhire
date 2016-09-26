class StagesController < ApplicationController
  before_action :setup_stages

  def index
  end

  def create
    new_stage = current_organization
                .stages
                .build(permitted_attributes(Stage))
    @stage = authorize(new_stage)

    if @stage.save
      flash[:notice] = 'Nice! Stage created.'
      redirect_to stages_url
    else
      render :index
    end
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
    authorize_stages
    StageOrderer.new(current_organization.stages)
                .reorder(params[:stages])

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

  def authorize_stages
    stage_ids = params[:stages].keys
    Stage.find(stage_ids).each { |stage| authorize stage }
  end

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
