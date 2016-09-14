class StageDecorator < Draper::Decorator
  delegate_all
  def list_item
    "#{order}. #{name}"
  end
end
