class StageDecorator < Draper::Decorator
  delegate_all
  
  def list_item
    "<strong class='order sortable-number'>#{order}.</strong> <strong>#{name}</strong>"
  end

  def delete_button_class
    !StagePolicy.deletable?(self) ? 'disabled' : ''
  end

  def modify_button_class
    !can_modify ? 'disabled' : ''
  end

  def modify_button_title
    if !can_modify
      'This stage cannot be edited'
    else
      'Modify stage'
    end
  end

  def delete_button_title
    if standard_stage_mapping.present? 
      'This stage cannot be deleted' 
    elsif candidates.any? 
      'Please remove candidates from stage to delete' 
    else 
      'Delete Stage' 
    end
  end

  private

  def can_modify
    !standard_stage_mapping.present?
  end

  def tooltip_needed
    candidates.any? || standard_stage_mapping.present?
  end
end
