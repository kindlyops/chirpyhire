class Inquiry < ActiveRecord::Base
  belongs_to :message
  belongs_to :question
  belongs_to :lead

  scope :recent, -> { where('created_at > ?', 2.days.ago) }

  def self.unanswered_recently_by(lead:)
    where.not(question: lead.recent_answers.pluck('DISTINCT question_id'))
  end
end
