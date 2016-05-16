class Action < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
  belongs_to :trigger

  def perform(user)
    message = actionable.perform(user)
    actionable.children.create(user: user, message_sid: message.sid)
  end

  def description
    actionable.template_name
  end
end
