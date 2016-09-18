class StagePolicy < ApplicationPolicy

  def create?
    true
  end

  def destroy?
    @record.default_stage_mapping.nil? && @record.candidates.empty?
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
