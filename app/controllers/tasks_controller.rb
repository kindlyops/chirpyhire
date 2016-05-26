class TasksController < ApplicationController
  def index
    @tasks = scoped_tasks
  end

  private

  def scoped_tasks
    policy_scope(Task)
  end
end
