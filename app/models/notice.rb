class Notice < ActiveRecord::Base
  has_many :rules, as: :action
  belongs_to :template
  delegate :name, to: :template, prefix: true
  delegate :organization, to: :template

  has_many :notifications

  def perform(user)
    message = user.receive_message(body: template.render(user))
    notifications.create(message: message)
  end
end
