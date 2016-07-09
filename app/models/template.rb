class Template < ApplicationRecord
  belongs_to :organization
  has_one :rules, as: :action
  has_many :notifications

  def render(user)
    Renderer.call(self, user)
  end

  def perform(user)
    message = user.receive_message(body: render(user))
    notification = notifications.create(user: user, message: message)
    notification.update(message_id: message.id)
    notification
  end
end
