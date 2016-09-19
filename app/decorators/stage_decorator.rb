class StageDecorator < Draper::Decorator
  delegate_all
  
  def list_item
    "<strong class='order sortable-number'>#{order}.</strong> <strong>#{name}</strong>"
  end

  def delete_button_class
    !StagePolicy.deletable?(self) ? 'disabled' : ''
  end

  def modify_button_class
    !StagePolicy.updatable?(self) ? 'disabled' : ''
  end

  def modify_button_title
    if !StagePolicy.updatable?(self)
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

  def tooltip_needed
    candidates.any? || standard_stage_mapping.present?
  end
end
