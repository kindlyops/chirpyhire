class Candidate < ApplicationRecord
  include PublicActivity::Model
  include Filterable
  tracked only: [:create, :update], on: {
    update: ->(model, _) { model.changes.include?('stage_id') }
  }, properties: ->(_, model) { { stage_id: model.stage_id } }

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
  delegate :stages, to: :organization

  before_create :ensure_candidate_has_stage, :add_nickname

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.with_addresses
    joins(:candidate_features).merge(CandidateFeature.address)
  end

  def self.stage_name(stage_name)
    joins(:stage).where(stages: { name: stage_name })
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
    return nil unless address_feature.present?
    Address.new(address_feature)
  end

  def zipcode
    zipcode_feature&.properties&.dig('whitelist_option')
  end

  def zipcode_feature
    features(ZipcodeQuestion).first
  end

  def address_feature
    features(AddressQuestion).first
  end

  def choice_features
    features(ChoiceQuestion)
  end

  def document_features
    features(DocumentQuestion)
  end

  def yes_no_features
    features(YesNoQuestion)
  end

  def features(question_class)
    candidate_features.where("properties->>'child_class' = ?",
                             question_class.child_class_property)
  end

  private

  def ensure_candidate_has_stage
    self.stage = organization.potential_stage unless stage.present?
  end

  def add_nickname
    self.nickname = Nicknames::Generator.new(self).generate
  end
end
