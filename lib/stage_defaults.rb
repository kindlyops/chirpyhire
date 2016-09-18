module StageDefaults
  def self.defaults(organization_id = nil)
    [
      Stage.new(organization_id: organization_id, name: "Potential", order: 1, standard_stage_mapping: Stage::POTENTIAL),
      Stage.new(organization_id: organization_id, name: "Qualified", order: 2, standard_stage_mapping: Stage::QUALIFIED),
      Stage.new(organization_id: organization_id, name: "Bad Fit", order: 3, standard_stage_mapping: Stage::BAD_FIT),
      Stage.new(organization_id: organization_id, name: "Hired", order: 4, standard_stage_mapping: Stage::HIRED)
    ]
  end
end
