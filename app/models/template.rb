class Template < ApplicationRecord
  belongs_to :organization
  has_many :notifications
  belongs_to :actionable, foreign_key: :actionable_id, class_name: "TemplateActionable", inverse_of: :template

  validates_presence_of :body, :name

  def perform(user)
    message = user.receive_message(body: body)
    notifications.create(message: message)
  end
end
