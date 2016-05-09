class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :observable, polymorphic: true
  has_many :actions
  enum status: [:enabled, :disabled]
  enum operation: [:subscribe, :answer, :invalid_answer]

  def fire(person)
    actions.each { |action| action.perform(person) }
  end

  def description
    observable.template_name
  end

  def actions_description
    actions.map(&:description).join(" + ")
  end
end
