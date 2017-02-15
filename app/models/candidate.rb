class Candidate < ApplicationRecord
  include Filterable
  include PublicActivity::Model
  tracked(
    only: [:create, :update],
    on: {
      update: ->(model, _) { model.changes.include?('stage_id') }
    },
    properties: ->(_, model) { { stage_id: model.stage_id } },
    owner: proc { |_, model| model.organization }
  )

  belongs_to :user
  belongs_to :stage
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals
  has_many :activities, as: :trackable

  alias features candidate_features

  delegate :first_name, :phone_number, :organization_name, :handle, :messages,
           :organization, :outstanding_inquiry, :receive_message,
           :outstanding_inquiry?, to: :user
  delegate :potential?, :qualified?, :bad_fit?, :hired?, to: :stage
  delegate :stages, to: :organization

  before_create :ensure_candidate_has_stage, :add_nickname

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.stage_name(stage_name)
    joins(:stage).where(stages: { name: stage_name })
  end

  def self.created_in(created_in)
    min_date = CandidateFilterable.min_date(created_in)
    return where(nil) unless min_date.present?
    where('candidates.created_at > ?', min_date)
  end

  # rubocop:disable Metrics/LineLength
  def self.zipcode(zipcode)
    return where(nil) if zipcode == CandidateFeature::ALL_ZIPCODES_CODE
    ids = joins(:candidate_features)
          .where("properties->>'child_class' = ?", ZipcodeQuestion.child_class_property)
          .where("properties->>'option' = ?", zipcode)
          .or(
            joins(:candidate_features)
                .where("properties->>'child_class' = ?", AddressQuestion.child_class_property)
                .where("properties->>'postal_code' = ?", zipcode)
          ).pluck(:id)
    Candidate.where(id: ids)
  end
  # rubocop:enable Metrics/LineLength

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
    address_feature.present? ? Address.new(address_feature) : nil
  end

  def zipcode
    full_zipcode = features(ZipcodeQuestion).first&.properties
      &.dig('option') || address&.zipcode
    full_zipcode[0..4] if full_zipcode.present?
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

  def availability
    feature = choice_features.find { |f| f.label == 'Availability' }
    return unless feature
    feature.properties['choice_option']
  end

  def transportation
    feature = yes_no_features.find { |f| f.label == 'Transportation' }
    return unless feature
    feature.properties['yes_no_option']
  end

  def experience
    feature = choice_features.find { |f| f.label == 'Experience' }
    return unless feature
    feature.properties['choice_option']
  end

  def certification
    feature = choice_features.find { |f| f.label == 'Certification' }
    return unless feature
    feature.properties['choice_option']
  end

  def cpr
    feature = choice_features.find { |f| f.label == 'CPR / 1st Aid' }
    return unless feature
    feature.properties['choice_option']
  end

  def skin_test
    feature = choice_features.find { |f| f.label == 'Skin Test' }
    return unless feature
    feature.properties['choice_option']
  end

  private

  def features(question_class)
    candidate_features.select do |f|
      f.properties['child_class'] == question_class.child_class_property
    end
  end

  def ensure_candidate_has_stage
    self.stage = organization.potential_stage unless stage.present?
  end

  def add_nickname
    self.nickname = Nicknames::Generator.new(self).generate
  rescue Nicknames::OutOfNicknamesError => e
    Logging::Logger.log(e)
    self.nickname = 'Anonymous'
  end
end
