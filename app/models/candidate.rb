class Candidate < ApplicationRecord
  include PublicActivity::Model
  include Filterable
  tracked only: [:create, :update], on: {
    update: ->(model, _) { model.changes.include?('stage_id') }
  },
          properties: ->(_, model) { { stage_id: model.stage_id } }

  belongs_to :user
  belongs_to :stage
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals
  has_many :activities, as: :trackable

  alias features candidate_features

  delegate :first_name, :phone_number, :organization_name,
           :organization, :messages, :outstanding_inquiry,
           :receive_message, :handle, :outstanding_inquiry?, to: :user

  delegate :potential?, :qualified?, :bad_fit?, :hired?, to: :stage

  before_create :ensure_candidate_has_stage

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.with_addresses
    joins(:candidate_features).merge(CandidateFeature.address)
  end

  def self.stage_id(stage_id)
    joins(:stage).where(stages: { id: stage_id })
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
    joins(:stage).merge(Stage.hired)
  end

  def self.qualified
    joins(:stage).merge(Stage.qualified)
  end

  def self.potential
    joins(:stage).merge(Stage.potential)
  end

  def self.bad_fit
    joins(:stage).merge(Stage.bad_fit)
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

  private

  def ensure_candidate_has_stage
    self.stage = organization.potential_stage unless stage.present?
  end
end
