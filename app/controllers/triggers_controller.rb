class TriggersController < ApplicationController
  decorates_assigned :trigger
  decorates_assigned :triggers

  def new
    trigger = scoped_triggers.build
    trigger.actions.build

    @trigger = authorize trigger
  end

  def edit
    @trigger = authorized_trigger
  end

  def create
    trigger = scoped_triggers.build(permitted_attributes(Trigger))
    authorize trigger

    if trigger.save
      redirect_to triggers_path, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if authorized_trigger.update(permitted_attributes(authorized_trigger))
      redirect_to triggers_path, notice: 'Rule was successfully updated.'
    else
      render :edit
    end
  end

  def index
    @triggers = scoped_triggers
  end

  def destroy
    authorized_trigger.destroy
    redirect_to triggers_path, notice: 'Rule was successfully destroyed.'
  end

  private

  def authorized_trigger
    authorize Trigger.find(params[:id])
  end

  def scoped_triggers
    policy_scope Trigger
  end
end
