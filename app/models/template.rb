class Template < ActiveRecord::Base
  belongs_to :organization
  has_one :rules, as: :action
  has_many :notifications

  def render(user)
    Renderer.call(self, user)
  end

  def perform(user)
    message = user.receive_message(body: render(user))
    notifications.create(user: user, message: message)
  end
end
