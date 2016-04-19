class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :lead
  belongs_to :message

  scope :recent, -> { where('created_at > ?', 30.days.ago) }
end
