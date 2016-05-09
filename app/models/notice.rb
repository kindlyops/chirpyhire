class Notice < ActiveRecord::Base
  belongs_to :template
  has_many :notifications
  has_many :actions, as: :actionable

  def children
    notifications
  end

  def perform(person)
    organization.send_message(to: person, body: template.render(person))
  end
end
