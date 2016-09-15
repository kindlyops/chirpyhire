class StageDecorator < Draper::Decorator
  delegate_all
  
  def list_item
    delete_button_class = if candidates.any? then 'disabled' else '' end
    delete_button_tipsy_class = if tipsy_needed then 'tipsy-needed-w' else '' end

    "<div class='stage-item-text'><div class='stage-item-text-wrapper'><span class='order'>#{order}.</span> #{name}</div></div>\
     <a class='delete-stage button #{delete_button_tipsy_class} #{delete_button_class}' \
        href='stages/delete/#{id}' \
        data-turbolinks='false' \
        title='#{button_title}'>\
       <i class='fa fa-trash-o'></i>\
     </a>".html_safe
  end

  private

  def button_title
    if default_stage_mapping.present? 
      'This stage cannot be deleted' 
    elsif candidates.any? 
      'Please remove candidates from stage to delete' 
    else 
      'Delete Stage' 
    end
  end

  def tipsy_needed
    candidates.any? || default_stage_mapping.present?
  end
end
