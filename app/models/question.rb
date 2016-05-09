class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  has_many :actions, as: :actionable

  enum response: [:text, :image]
  delegate :organization, to: :template

  def children
    inquiries
  end

  def perform(person)
    organization.send_message(to: person, body: template.render(person))
  end
end
