class StagesController < ApplicationController
  before_action :setup_stages

  def index
  end

  def create
    if create_new_stage(params[:new_stage])
      flash[:notice] = 'Nice! Stage created.'
    end
    redirect_to stages_url
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
    StageOrderer.new(current_organization.id)
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

  def create_new_stage(new_stage_name)
    @stage = authorize(current_organization.stages.build(
                         name: new_stage_name,
                         order: current_organization.stages.maximum(:order) + 1
    ))
    @stage.save
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
