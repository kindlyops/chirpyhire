class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  has_many :actions, as: :actionable
  has_one :trigger, as: :observable

  enum format: [:text, :media]
  delegate :organization, to: :template
  delegate :name, to: :template, prefix: true

  def children
    inquiries
  end

  def perform(user)
    user.receive_message(body: template.render(user))
  end
end
