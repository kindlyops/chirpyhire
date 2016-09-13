class Activity < PublicActivity::Activity
  def self.for_stage_id(stage_id)
    where("properties->'stage_id' = ?", stage_id.to_s)
  end
end
