class TasksController < ApplicationController
  decorates_assigned :task

  def show
    @task = authorized_task

    render layout: false
  end

  def index
    @tasks = scoped_tasks
  end

  def update
    authorized_task.update(permitted_attributes(Task))
    @task = authorized_task

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_tasks
    policy_scope(Task).outstanding
  end

  def authorized_task
    authorize Task.find(params[:id])
  end
end
