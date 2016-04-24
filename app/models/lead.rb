class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :referrers, through: :referrals
  has_many :inquiries
  has_many :answers
  has_many :search_leads
  has_many :searches, through: :search_leads
  has_many :search_questions, through: :searches
  has_many :questions, through: :search_questions

  delegate :first_name, :name, :phone_number, to: :user

  scope :subscribed, -> { joins(user: :subscriptions) }

  def prelude
    "Hey #{first_name}, this is #{organization.owner_first_name} \
and #{organization.name}. We have a new client and want to see if you \
might be a good fit."
  end

  def preamble
    "Reply Y or N."
  end

  def last_referrer
    @last_referrer ||= begin
      return NullReferrer.new unless referrers.present?
      last_referral.referrer
    end
  end

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def last_referred_at
    last_referral.created_at
  end

  def last_referrer_name
    last_referrer.name
  end

  def last_referrer_phone_number
    last_referrer.phone_number
  end

  def subscribe
    user.subscribe_to(organization)
  end

  def subscribed?
    user.subscribed_to?(organization)
  end

  def unsubscribe
    user.unsubscribe_from(organization)
  end

  def unsubscribed?
    user.unsubscribed_from?(organization)
  end

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
