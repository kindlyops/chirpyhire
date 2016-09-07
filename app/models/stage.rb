class Stage < ApplicationRecord
  belongs_to :organization

  def self.defaults(organization_id = nil)
    [
      Stage.new(organization_id: organization_id, name: "Potential", order: 1),
      Stage.new(organization_id: organization_id, name: "Qualified", order: 2),
      Stage.new(organization_id: organization_id, name: "Bad Fit", order: 3),
      Stage.new(organization_id: organization_id, name: "Hired", order: 4)
    ]
  end
end
