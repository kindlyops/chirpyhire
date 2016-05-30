class Trigger < ActiveRecord::Base
  belongs_to :organization
  has_many :rules
  has_one :question

  validates :event, inclusion: { in: %w(subscribe screen) }

  def decorator_class
    "#{event.humanize}Decorator".constantize
  end

  def self.for(event)
    where(event: event)
  end
end
