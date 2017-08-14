class BotActionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(bot: :organization)
        .where(bots: { organization: organization })
    end
  end
end
