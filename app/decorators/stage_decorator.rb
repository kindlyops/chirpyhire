class StageDecorator < Draper::Decorator
  delegate_all
  def list_item
    "<span class=order>#{order}.</span> #{name}".html_safe
  end
end
