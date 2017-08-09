class FollowUpPolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  def create?
    record.new_record?
  end

  def permitted_attributes
    %i[body response bot_action_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(question: :bot)
        .where(questions: { bots: { organization: organization } })
    end
  end
end
