class StageDecorator < Draper::Decorator
  delegate_all
  
  def list_item
    delete_button_disabled_class = if candidates.any? then 'disabled' else '' end
    delete_button_tipsy_class = if candidates.any? || default_stage_mapping.present? then 'tipsy-needed-w' else '' end

    delete_button_title = 
      if default_stage_mapping.present? 
        then 'This stage cannot be deleted' 
      elsif candidates.any? 
        then 'Please remove candidates from stage to delete' 
      else 'Delete Stage' 
      end

    "<div class='stage-item-text'><div class='stage-item-text-wrapper'><span class='order'>#{order}.</span> #{name}</div></div>\
     <button class='delete-stage #{delete_button_tipsy_class} #{delete_button_disabled_class}' title='#{delete_button_title}' data-id='#{id}'>\
       <i class='fa fa-trash-o'></i>\
     </button>".html_safe
  end
end
