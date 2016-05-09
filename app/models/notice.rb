class Notice < ActiveRecord::Base
  belongs_to :template
  delegate :name, to: :template, prefix: true

  has_many :notifications
  has_many :actions, as: :actionable

  def children
    notifications
  end

  def perform(person)
    person.receive_message(body: template.render(person))
  end
end
