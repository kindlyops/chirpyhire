class Trigger < ActiveRecord::Base
  belongs_to :organization
  has_many :actions
  enum status: [:enabled, :disabled]

  def fire(person)
    actions.each { |action| action.perform(person) }
  end
end
