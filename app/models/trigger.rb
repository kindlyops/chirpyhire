class Trigger < ActiveRecord::Base
  validates :event, inclusion: { in: %w(subscribe screen answer) }

  def decorator_class
    "#{event.humanize}Decorator".constantize
  end

  def self.for(event)
    find_by(event: event)
  end
end
