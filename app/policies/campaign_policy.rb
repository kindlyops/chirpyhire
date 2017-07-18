class CampaignPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def update?
    show?
  end

  def permitted_attributes
    %i[name]
      .push(bot_campaign)
  end

  def bot_campaign
    { bot_campaign_attributes: bot_campaign_attributes }
  end

  def bot_campaign_attributes
    %i[inbox_id bot_id campaign_id id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
