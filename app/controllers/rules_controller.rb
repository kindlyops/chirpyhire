class RulesController < ApplicationController
  decorates_assigned :rule
  decorates_assigned :rules

  def new
    rule = scoped_rules.build

    @rule = authorize rule
  end

  def show
    @rule = authorized_rule
  end

  def edit
    @rule = authorized_rule
  end

  def create
    rule = scoped_rules.build(permitted_attributes(Rule))
    authorize rule
    if rule.save
      redirect_to rule, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if authorized_rule.update(permitted_attributes(authorized_rule))
      redirect_to authorized_rule, notice: 'Rule was successfully updated.'
    else
      render :show
    end
  end

  private

  def authorized_rule
    authorize Rule.find(params[:id])
  end

  def authorized_automation
    automation = Automation.find(params[:automation_id])
    raise Pundit::NotAuthorizedError unless AutomationPolicy.new(current_account, automation).show?
    automation
  end

  def scoped_rules
    policy_scope(Rule).where(automation: authorized_automation)
  end
end
