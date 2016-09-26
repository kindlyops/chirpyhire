class StageOrderer
  def initialize(stages)
    @stages = stages.ordered
  end

  def reorder(stages_with_order)
    Organization.transaction do
      clear_stage_order_positions_for_update
      update_stages_to_new_values(stages_with_order)
    end
  end

  def reset
    Stage.transaction do
      stages.each_with_index do |stage, index|
        stage.update!(order: index + 1)
      end
    end
  end

  private

  attr_reader :stages

  def clear_stage_order_positions_for_update
    # To avoid Unique Key errors, set all values to
    # their negative before updating
    stages.each do |stage|
      stage.update!(order: stage.order * -1)
    end
  end

  def update_stages_to_new_values(stages_with_order)
    stages.each do |stage|
      stage.update!(order: stages_with_order[stage.id.to_s][:order].to_i)
    end
  end
end
