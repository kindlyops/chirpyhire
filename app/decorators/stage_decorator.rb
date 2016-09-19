class StageDecorator < Draper::Decorator
  delegate_all
  
  def list_item
    "<span class='order sortable-number'>#{order}.</span> #{name}"
  end

  def delete_button_class
    if StagePolicy.deletable?(self) then '' else 'disabled' end
  end

  def delete_button_tipsy_class
    if tooltip_needed then 'tipsy-needed-w' else '' end
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
