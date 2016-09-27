module StageDefaults
  def self.populate(organization)
    return false unless organization.stages.empty?
    DEFAULTS.map(&organization.stages.method(:build))
    true
  end

  def self.count
    DEFAULTS.count
  end

  DEFAULTS =
    [
      {
        name: 'Potential',
        order: 1,
        standard_stage_mapping: Stage::POTENTIAL
      },
      {
        name: 'Qualified',
        order: 2,
        standard_stage_mapping: Stage::QUALIFIED
      },
      {
        name: 'Bad Fit',
        order: 3,
        standard_stage_mapping: Stage::BAD_FIT
      },
      {
        name: 'Hired',
        order: 4,
        standard_stage_mapping: Stage::HIRED
      }
    ].freeze
  private_constant :DEFAULTS
end
