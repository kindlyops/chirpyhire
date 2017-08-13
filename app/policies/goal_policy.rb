class GoalPolicy < ApplicationPolicy
  def update?
    show? && record.bot.inactive?
  end

  def create?
    record.new_record? && record.bot.inactive?
  end

  def permitted_attributes
    %i[body contact_stage_id id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:bot).where(bots: { organization: organization })
    end
  end
end
