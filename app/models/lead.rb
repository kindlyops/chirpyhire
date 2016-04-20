class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :inquiries
  has_many :answers
  has_many :search_leads
  has_many :searches, through: :search_leads
  has_many :search_questions, through: :searches
  has_many :questions, through: :search_questions

  delegate :first_name, :phone_number, to: :user

  def recently_answered?(question)
    recent_answers.where(question: question).exists?
  end

  def next_questions_for(question)
    questions.where(id: search_questions.where(question: question).pluck('DISTINCT next_question_id'))
  end

  def questions_unasked_recently
    questions.where.not(id: recent_inquiries.pluck('DISTINCT question_id'))
  end

  def has_unanswered_recent_inquiry?
    recent_inquiries.unanswered_recently_by(lead: self).exists?
  end

  def most_recent_inquiry
    inquiries.order(created_at: :desc).first
  end

  def recent_inquiries
    inquiries.recent
  end

  def recent_answers
    answers.recent
  end
end
