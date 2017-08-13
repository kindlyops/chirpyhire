class QuestionPolicy < ApplicationPolicy
  def update?
    show? && !record.bot.active?
  end

  def create?
    record.new_record? && !record.bot.active?
  end

  def permitted_attributes
    %i[body id active].push(follow_ups)
  end

  def follow_ups
    { follow_ups_attributes: follow_ups_attributes }
  end

  def follow_ups_attributes
    %i[body response bot_action_id rank].push(taggings)
  end

  def taggings
    { follow_ups_taggings_attributes: follow_ups_taggings }
  end

  def follow_ups_taggings
    %i[tag_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:bot).where(bots: { organization: organization })
    end
  end
end
