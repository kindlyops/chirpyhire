class TasksController < ApplicationController
  def index
    @tasks = scoped_tasks
  end

  def update
    authorized_task.update(permitted_attributes(Task))

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_tasks
    policy_scope(Task)
  end

  def authorized_task
    authorize Task.find(params[:id])
  end
end
