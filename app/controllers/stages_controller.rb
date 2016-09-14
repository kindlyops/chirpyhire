class StagesController < ApplicationController
  def index
    @stages = scoped_stages.ordered.decorate
  end

  def create
    new_stage_name = params[:new_stage]
    stages = current_organization.stages
    if stages.exists?(name: new_stage_name)
      skip_authorization
      redirect_to stages_url, alert: "Oops! You already have a stage with that name."
    elsif create_new_stage(new_stage_name)
      redirect_to stages_url, notice: "Nice! Stage created."
    else
       Rollbar.error(stage.errors)
      redirect_to stages_url, alert: "Oops! We were unable to create your stage."
    end
  end

  def update
  end

  def destroy
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
