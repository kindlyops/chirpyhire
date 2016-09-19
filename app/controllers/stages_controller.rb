class StagesController < ApplicationController
  before_action :setup_stages

  def index
  end

  def create
    if create_new_stage(params[:new_stage])
      redirect_to stages_url, notice: "Nice! Stage created."
    else
      render :index
    end
  end

  def edit
    @stage = authorize(Stage.find(params[:id]))
  end

  def reorder
    authorize Stage  
    stages_with_new_order = scoped_stages.map do |stage|
      { id: stage.id, order: params[stage.id.to_s] }
    end
    current_organization.reorder_stages(stages_with_new_order)
    redirect_to stages_url, notice: "Nice! Stage order saved."
  end

  def destroy
    if authorize(Stage.find(params[:id])).destroy
      redirect_to stages_url, notice: "Nice! Stage deleted."
    else
      redirect_to stages_url, alert: "Oops! We were unable to delete your stage."
    end
  end

  private

  def setup_stages
    @stages = scoped_stages.decorate
    @stage = Stage.new
  end

  def create_new_stage(new_stage_name)
    @stage = authorize(Stage.new(
      organization: current_organization,
      name: new_stage_name,
      order: current_organization.stages.maximum(:order) + 1))
    @stage.save
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
