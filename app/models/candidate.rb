class Candidate < ApplicationRecord
  paginates_per 4

  belongs_to :user
  belongs_to :candidate_persona
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals

  alias :features :candidate_features

  STATUSES = ["Potential", "Qualified", "Screened", "Bad Fit"]
  validates :status, inclusion: { in: STATUSES }

  delegate :first_name, :phone_number, :organization_name,
           :organization, :messages, :outstanding_inquiry,
           :receive_message, to: :user

  def self.status(status)
    return self unless status.present?
    where(status: status)
  end

  def next_persona_feature
    candidate_persona.features.next_for(self)
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

  def qualified?
    status == "Qualified"
  end

  def bad_fit?
    status == "Bad Fit"
  end

  def potential?
    status == "Potential"
  end

  def screened?
    status == "Screened"
  end
end
