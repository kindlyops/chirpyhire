class FollowUpPolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show? && record.bot.inactive?
  end

  def new?
    record.new_record?
  end

  def create?
    record.new_record? && record.bot.inactive?
  end

  def permitted_attributes
    %i[body response bot_action_id type]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(question: :bot)
        .where(questions: { bots: { organization: organization } })
    end
  end
end
