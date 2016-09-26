class Activity < PublicActivity::Activity
  def self.for_stage(stage)
    where("properties->'stage_id' = ?", stage.id.to_s)
  end
end
