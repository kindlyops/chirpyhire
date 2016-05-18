class TriggersController < ApplicationController

  def new
    trigger = triggers.build
    @trigger = TriggerPresenter.new(authorize trigger)
  end

  def edit
    @trigger = TriggerPresenter.new(trigger)
  end

  def create
    trigger = triggers.build(permitted_attributes(Trigger))
    authorize trigger

    if trigger.save
      redirect_to triggers_path, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if trigger.update(permitted_attributes(trigger))
      redirect_to triggers_path, notice: 'Rule was successfully updated.'
    else
      render :edit
    end
  end

  def index
    @triggers = TriggersPresenter.new(triggers)
  end

  def destroy
    trigger.destroy
    redirect_to triggers_path, notice: 'Rule was successfully destroyed.'
  end

  private

  def trigger
    authorize Trigger.find(params[:id])
  end

  def triggers
    policy_scope Trigger
  end
end
