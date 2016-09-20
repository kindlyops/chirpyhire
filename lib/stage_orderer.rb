class StageOrderer
  def self.reset_orders(organization_id)
    stages = Organization.find(organization_id).stages.ordered
    Stage.transaction do
      stages.each_with_index do |stage, index|
        stage.order = index + 1
        stage.save!
      end
    end
 end
end
