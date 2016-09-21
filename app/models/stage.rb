class Stage < ApplicationRecord
  belongs_to :organization
  has_many :candidates
  validates :name, uniqueness: { scope: :organization }

  POTENTIAL = 0
  QUALIFIED = 1
  BAD_FIT = 2
  HIRED = 3

  enum standard_stage_mapping: {
    potential: Stage::POTENTIAL,
    qualified: Stage::QUALIFIED,
    bad_fit: Stage::BAD_FIT,
    hired: Stage::HIRED
  }

  def self.ordered
    order(:order)
  end

  after_destroy do |stage|
    StageOrderer.reset_orders(stage.organization_id)
  end
end
