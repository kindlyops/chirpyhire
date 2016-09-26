class StagePolicy < ApplicationPolicy
  def show?
    record.organization == organization
  end

  def create?
    show?
  end

  def edit?
    self.class.updatable?(record) && show?
  end

  def update?
    edit?
  end

  def reorder?
    show?
  end

  def destroy?
    self.class.deletable?(record) && show?
  end

  def permitted_attributes
    [:name, :order]
  end

  def self.updatable?(stage)
    stage.standard_stage_mapping.blank?
  end

  def self.deletable?(stage)
    stage.standard_stage_mapping.blank? && stage.candidates.empty?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.ordered_stages
    end
  end
end
