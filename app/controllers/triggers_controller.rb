class TriggersController < ApplicationController

  def new
    @trigger = TriggerPresenter.new(authorize triggers.build)
  end

  def edit
    @trigger = TriggerPresenter.new(trigger)
  end

  def create
    trigger = triggers.build(permitted_attributes(trigger))

    if trigger.save
      redirect_to trigger, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if trigger.update(permitted_attributes(trigger))
      redirect_to trigger, notice: 'Rule was successfully updated.'
    else
      render :edit
    end
  end

  def index
    @triggers = TriggersPresenter.new(triggers)
  end

  private

  def trigger
    authorize Trigger.find(params[:id])
  end

  def triggers
    policy_scope Trigger
  end
end
