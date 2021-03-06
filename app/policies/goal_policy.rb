class GoalPolicy < ApplicationPolicy
  def update?
    show? && record.bot.inactive?
  end

  def create?
    record.new_record? && record.bot.inactive?
  end

  def destroy?
    update? && record.bot.goals.count > 1
  end

  def permitted_attributes
    %i[body contact_stage_id id alert]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:bot).where(bots: { organization: organization })
    end
  end
end
