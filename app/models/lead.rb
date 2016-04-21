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

  def has_other_search_in_progress?(search)
    search_leads.where.not(search: search).processing.exists?
  end

  def has_pending_searches?
    search_leads.pending.exists?
  end

  def oldest_pending_search_lead
    search_leads.pending.order(:created_at).first
  end

  def recently_answered_negatively?(question)
    answers.to(question).recent.negative.exists?
  end

  def recently_answered_positively?(question)
    answers.to(question).recent.positive.exists?
  end

  def most_recent_inquiry
    inquiries.order(created_at: :desc).first
  end

  def processing_search_lead
    search_leads.processing.first
  end
end
