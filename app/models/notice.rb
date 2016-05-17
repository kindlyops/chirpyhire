class Notice < ActiveRecord::Base
  belongs_to :template
  delegate :name, to: :template, prefix: true

  has_many :notifications
  has_many :actions, as: :actionable

  def perform(user)
    message = user.receive_message(body: template.render(user))
    notifications.create(user: user, message_sid: message.sid)
  end
end
