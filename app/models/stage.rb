class Stage < ApplicationRecord
  belongs_to :organization
  has_many :candidates

  POTENTIAL = 0
  QUALIFIED = 1
  BAD_FIT = 2
  HIRED = 3

  @@default_stage_mapping = { potential: Stage::POTENTIAL, qualified: Stage::QUALIFIED, bad_fit: Stage::BAD_FIT, hired: Stage::HIRED}
  enum default_stage_mapping: @@default_stage_mapping

  def self.ordered
    order(:order)
  end

  def self.by_default(stage)
    where(default_stage_mapping: stage)
  end

  def self.default_potential
    self.by_default(Stage::POTENTIAL)
  end

  def self.default_qualified
    self.by_default(Stage::QUALIFIED)
  end

  def self.default_bad_fit
    self.by_default(Stage::BAD_FIT)
  end

  def self.default_hired
    self.by_default(Stage::HIRED)
  end

  def self.defaults(organization_id = nil)
    [
      Stage.new(organization_id: organization_id, name: "Potential", order: 1, default_stage_mapping: @@default_stage_mapping[:potential]),
      Stage.new(organization_id: organization_id, name: "Qualified", order: 2, default_stage_mapping: @@default_stage_mapping[:qualified]),
      Stage.new(organization_id: organization_id, name: "Bad Fit", order: 3, default_stage_mapping: @@default_stage_mapping[:bad_fit]),
      Stage.new(organization_id: organization_id, name: "Hired", order: 4, default_stage_mapping: @@default_stage_mapping[:hired])
    ]
  end

  private
  
  after_destroy do |stage|
    reset_orders(stage.organization_id)
  end

  # TODO JLW Add test
  def reset_orders(organization_id) 
    stages = Organization.find(organization_id).stages.ordered
    Stage.transaction do
      stages.each_with_index do |stage, index|
        stage.order = index + 1
        stage.save!
      end
    end
  end
end
