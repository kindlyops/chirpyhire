class BotPolicy < ApplicationPolicy
  def update?
    show? && no_active_campaigns?
  end

  def clone?
    show?
  end

  def permitted_attributes
    %i[name]
      .push(greeting)
      .push(questions)
      .push(goals)
  end

  def greeting
    { greeting_attributes: greeting_attributes }
  end

  def questions
    { questions_attributes: questions_attributes }
  end

  def goals
    { goals_attributes: goals_attributes }
  end

  def greeting_attributes
    %i[body id]
  end

  def questions_attributes
    %i[body id active].push(follow_ups)
  end

  def follow_ups
    { follow_ups_attributes: follow_ups_attributes }
  end

  def follow_ups_attributes
    %i[body id _destroy]
  end

  def goals_attributes
    %i[body contact_stage_id id]
  end

  def no_active_campaigns?
    record.campaigns.none?(&:active?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
