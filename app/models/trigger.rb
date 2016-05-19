class Trigger < ActiveRecord::Base
  belongs_to :organization
  has_many :rules
  has_one :question

  delegate :template_name, to: :question
  validates :event, inclusion: { in: %w(subscribe answer) }
end
