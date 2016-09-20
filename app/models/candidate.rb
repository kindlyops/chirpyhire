class Candidate < ApplicationRecord
  include PublicActivity::Model
  include Filterable
  tracked only: [:create, :update], on: {
    update: ->(model, _) { model.changes.include?('status') }
  }, properties: ->(_, model) { { status: model.status } }

  belongs_to :user
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals
  has_many :activities, as: :trackable

  alias features candidate_features

  STATUSES = ['Potential', 'Qualified', 'Bad Fit', 'Hired'].freeze
  validates :status, inclusion: { in: STATUSES }

  delegate :first_name, :phone_number, :organization_name,
           :organization, :messages, :outstanding_inquiry,
           :receive_message, :handle, :outstanding_inquiry?, to: :user

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.with_addresses
    joins(:candidate_features).merge(CandidateFeature.address)
  end

  def self.status(status)
    where(status: status)
  end

  def self.created_in(created_in)
    period = {
      'Past 24 Hours' => 24.hours.ago,
      'Past Week' => 1.week.ago,
      'Past Month' => 1.month.ago,
      'All Time' => Date.iso8601('2016-02-01')

    }[created_in]
    return self unless period.present?

    where('candidates.created_at > ?', period)
  end

  def self.hired
    where(status: 'Hired')
  end

  def self.qualified
    where(status: 'Qualified')
  end

  def self.potential
    where(status: 'Potential')
  end

  def self.bad_fit
    where(status: 'Bad Fit')
  end

  def address
    return NullAddress.new unless address_feature.present?
    Address.new(address_feature)
  end

  def address_feature
    candidate_features.find_by("properties->>'child_class' = ?", 'address')
  end

  def choice_features
    candidate_features.where("properties->>'child_class' = ?", 'choice')
  end

  def document_features
    candidate_features.where("properties->>'child_class' = ?", 'document')
  end

  def yes_no_features
    candidate_features.where("properties->>'child_class' = ?", 'yes_no')
  end

  def qualified?
    status == 'Qualified'
  end

  def bad_fit?
    status == 'Bad Fit'
  end

  def potential?
    status == 'Potential'
  end

  def hired?
    status == 'Hired'
  end
end
