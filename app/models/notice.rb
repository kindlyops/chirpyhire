class Notice < ActiveRecord::Base
  belongs_to :template
  delegate :name, to: :template, prefix: true
  delegate :organization, to: :template

  has_many :notifications
  belongs_to :action

  def perform(user)
    message = user.receive_message(body: template.render(user))
    notifications.create(user: user, message_sid: message.sid)
  end
end
