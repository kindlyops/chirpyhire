class StagePolicy < ApplicationPolicy

  def create?
    true
  end

  def destroy?
    self.class.deletable?(record)
  end

  def self.deletable?(stage)
    stage.standard_stage_mapping.nil? && stage.candidates.empty?
  end

  def reorder?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.stages
    end
  end
end
