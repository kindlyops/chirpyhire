# frozen_string_literal: true
class CandidatePolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    [:status]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.candidates
    end
  end
end
