class Notice < ActiveRecord::Base
  belongs_to :template
  delegate :name, to: :template, prefix: true

  has_many :notifications
  has_many :actions, as: :actionable

  def children
    notifications
  end

  def perform(user)
    user.receive_message(body: template.render(user))
  end
end
