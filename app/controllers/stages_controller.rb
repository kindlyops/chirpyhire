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
    new_stage_order = build_new_stage_order
    StageOrderer.new(current_organization.id)
                .reorder(new_stage_order)

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

  def build_new_stage_order
    stage_order_array = scoped_stages.map do |stage|
      [stage.id, { order: params[stage.id.to_s] }]
    end
    new_stage_order = Hash[stage_order_array]
    stages = Stage.find(new_stage_order.keys)
    stages.each { |stage| authorize stage }
    new_stage_order
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
