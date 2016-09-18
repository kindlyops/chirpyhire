class StagesController < ApplicationController
  def index
    @stages = scoped_stages.decorate
  end

  def create
    new_stage_name = params[:new_stage]
    stages = current_organization.stages
    if stages.exists?(name: new_stage_name)
      authorize Stage.none
      redirect_to stages_url, alert: "Oops! You already have a stage with that name."
    elsif create_new_stage(new_stage_name)
      redirect_to stages_url, notice: "Nice! Stage created."
    else
      redirect_to stages_url, alert: "Oops! We were unable to create your stage."
    end
  end

  def reorder
    skip_authorization
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

  def create_new_stage(new_stage_name)
    stage = authorize(Stage.new(
      organization: current_organization,
      name: new_stage_name,
      order: current_organization.stages.map(&:order).max + 1))
    stage.save
  end

  def scoped_stages
    policy_scope(Stage)
  end
end
