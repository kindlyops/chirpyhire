class Activity < PublicActivity::Activity
  belongs_to :inquiry, foreign_key: 'trackable_id'
  def self.for_stage(stage)
    where("properties->'stage_id' = ?", stage.id.to_s)
  end
end
