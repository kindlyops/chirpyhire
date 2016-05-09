class Action < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
  belongs_to :trigger

  def perform(person)
    actionable.children.create(message: actionable.perform(person))
  end

  def description
    actionable.template_name
  end
end
