class Question < ActiveRecord::Base
  enum category: [:schedule, :experience, :location, :credentials]

  has_many :inquiries

  def self.next_questions_for(lead:, question:)
    where(id: lead.search_questions.where(question: question).pluck(:next_question_id))
  end

  def self.unasked_recently_of(lead:)
    where.not(id: lead.recent_answers.pluck('DISTINCT question_id'))
  end
end
