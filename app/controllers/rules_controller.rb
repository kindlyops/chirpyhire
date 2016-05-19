class RulesController < ApplicationController
  decorates_assigned :rule
  decorates_assigned :rules

  def new
    rule = scoped_rules.build

    @rule = authorize rule
  end

  def edit
    @rule = authorized_rule
  end

  def create
    rule = scoped_rules.build(permitted_attributes(Rule))
    authorize rule

    if rule.save
      redirect_to rules_path, notice: 'Rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if authorized_rule.update(permitted_attributes(authorized_rule))
      redirect_to rules_path, notice: 'Rule was successfully updated.'
    else
      render :edit
    end
  end

  def index
    @rules = scoped_rules
  end

  def destroy
    authorized_rule.destroy
    redirect_to rules_path, notice: 'Rule was successfully destroyed.'
  end

  private

  def authorized_rule
    authorize Rule.find(params[:id])
  end

  def scoped_rules
    policy_scope Rule
  end
end
