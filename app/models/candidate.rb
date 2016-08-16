class Candidate < ApplicationRecord
  include PublicActivity::Model
  tracked only: [:create, :update], on: {
    update: ->(model,_) { model.changes.include?("status") }
  }, params: { status: :status }

  belongs_to :user
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals

  alias :features :candidate_features

  STATUSES = ["Potential", "Qualified", "Bad Fit", "Hired"]
  validates :status, inclusion: { in: STATUSES }

  delegate :first_name, :phone_number, :organization_name,
           :organization, :messages, :outstanding_inquiry,
           :receive_message, to: :user

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.with_addresses
    joins(:candidate_features).merge(CandidateFeature.address)
  end

  def self.status(status)
    return self unless status.present?
    where(status: status)
  end

  def self.hired
    where(status: "Hired")
  end

  def self.qualified
    where(status: "Qualified")
  end

  def self.potential
    where(status: "Potential")
  end

  def self.bad_fit
    where(status: "Bad Fit")
  end

  def address
    return NullAddress.new unless address_feature.present?
    Address.new(address_feature)
  end

  def address_feature
    candidate_features.where("properties->>'child_class' = ?", "address").first
  end

  def choice_features
    candidate_features.where("properties->>'child_class' = ?", "choice")
  end

  def document_features
    candidate_features.where("properties->>'child_class' = ?", "document")
  end

  def yes_no_features
    candidate_features.where("properties->>'child_class' = ?", "yes_no")
  end

  def qualified?
    status == "Qualified"
  end

  def bad_fit?
    status == "Bad Fit"
  end

  def potential?
    status == "Potential"
  end

  def hired?
    status == "Hired"
  end
end
