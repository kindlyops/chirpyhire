module Stageable
  extend ActiveSupport::Concern

  included do
    has_many :stages
    accepts_nested_attributes_for :stages
  end

  # There should only ever be one of each default type for an organization
  def bad_fit_stage
    stages.bad_fit.first
  end

  def potential_stage
    stages.potential.first
  end

  def qualified_stage
    stages.qualified.first
  end

  def hired_stage
    stages.hired.first
  end
end
