class RulesController < ApplicationController
  decorates_assigned :rule, :rules

  def index
    @rules = scoped_rules
  end

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
    if authorized_rule.update(permitted_attributes(Rule))
      redirect_to authorized_rule, notice: 'Rule was successfully updated.'
    else
      render :show
    end
  end

  private

  def authorized_rule
    authorize Rule.find(params[:id])
  end

  def scoped_rules
    policy_scope(Rule)
  end
end
