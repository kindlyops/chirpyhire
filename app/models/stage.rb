class Stage < ApplicationRecord
  belongs_to :organization
  has_many :candidates
  @@default_stage_mapping = { potential: 0, qualified: 1, bad_fit: 2}
  enum default_stage_mapping: @@default_stage_mapping

  def self.default_stage_mapping
    @@default_stage_mapping
  end

  def self.defaults(organization_id = nil)
    [
      Stage.new(organization_id: organization_id, name: "Potential", order: 1, default_stage_mapping: @@default_stage_mapping[:potential] ),
      Stage.new(organization_id: organization_id, name: "Qualified", order: 2, default_stage_mapping: @@default_stage_mapping[:qualified]),
      Stage.new(organization_id: organization_id, name: "Bad Fit", order: 3, default_stage_mapping: @@default_stage_mapping[:bad_fit]),
      Stage.new(organization_id: organization_id, name: "Hired", order: 4)
    ]
  end
end
