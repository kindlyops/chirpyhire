class Notice < ActiveRecord::Base
  belongs_to :template
  delegate :name, to: :template, prefix: true
  delegate :organization, to: :template

  has_many :notifications
  belongs_to :action

  def action
    super || create_action(organization: organization)
  end

  def perform(user)
    message = user.receive_message(body: template.render(user))
    notifications.create(message: message)
  end
end
