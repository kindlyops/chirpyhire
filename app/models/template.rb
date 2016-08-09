class Template < ApplicationRecord
  belongs_to :organization
  has_many :notifications
  has_one :survey
  belongs_to :actionable, foreign_key: :actionable_id, class_name: "TemplateActionable", inverse_of: :template

  def perform(user)
    message = user.receive_message(body: body(with_postlude: true))
    notifications.create(message: message)
  end

  def body(with_postlude: false)
    if name == "Welcome" && with_postlude
      super() << "\n\n" << welcome_postlude
    else
      super()
    end
  end

  private

  def welcome_postlude
    "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
  end
end
