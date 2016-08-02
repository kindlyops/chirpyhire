class Template < ApplicationRecord
  belongs_to :organization
  has_many :notifications
  has_one :survey
  belongs_to :actionable, foreign_key: :actionable_id, class_name: "TemplateActionable", inverse_of: :template

  def render(user)
    Renderer.call(self, user)
  end

  def perform(user)
    message = user.receive_message(body: render(user))
    notifications.create(message: message)
  end
end
