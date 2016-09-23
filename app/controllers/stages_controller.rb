class StagesController < ApplicationController
  before_action :setup_stages

  def index
  end

  def create
    if create_new_stage(params[:new_stage])
      flash[:notice] = 'Nice! Stage created.'
    end
    render :index
  end

  def edit
    @stage = authorized_stage
  end

  def update
    @stage = authorized_stage
    if @stage.update(permitted_attributes(Stage))
      flash[:notice] = "Nice! Stage \"#{authorized_stage.name}\" updated."
      render :index
    else
      render :edit
    end
  end

  def reorder
    authorize Stage
    new_stage_order = build_new_stage_order
    StageOrderer.new(current_organization.id)
                .reorder(new_stage_order)

    flash[:notice] = 'Nice! Stage order saved.'
    render :index
  end

  def destroy
    if authorize(Stage.find(params[:id])).destroy
      flash[:notice] = 'Nice! Stage deleted.'
    end
    render :index
  end

  private

  def authorized_stage
    authorize(Stage.find(params[:id]))
  end

  def setup_stages
    @stages = scoped_stages.decorate
    @stage = Stage.new
  end

  def create_new_stage(new_stage_name)
    @stage = authorize(current_organization.stages.build(
                         name: new_stage_name,
                         order: current_organization.stages.maximum(:order) + 1
    ))
    @stage.save
  end

  def build_new_stage_order
    stage_order_array = scoped_stages.map do |stage|
      [stage.id, { order: params[stage.id.to_s] }]
    end
    Hash[stage_order_array]
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
