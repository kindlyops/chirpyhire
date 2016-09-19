class StagePolicy < ApplicationPolicy

  def create?
    true
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def reorder?
    true
  end

  def destroy?
    self.class.deletable?(record)
  end

  def permitted_attributes
    [:name]
  end

  def self.deletable?(stage)
    stage.standard_stage_mapping.nil? && stage.candidates.empty?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.stages
    end
  end
end
