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

  CREATED_IN_OPTIONS = {
    PAST_24_HOURS: 'Past 24 Hours',
    PAST_WEEK: 'Past Week',
    PAST_MONTH: 'Past Month',
    ALL_TIME: 'All Time'
  }.freeze

  def self.by_recency
    order(created_at: :desc, id: :desc)
  end

  def self.stage_name(stage_name)
    joins(:stage).where(stages: { name: stage_name })
  end

  def self.created_in(created_in)
    min_date = min_date(created_in)
    return where(nil) unless min_date.present?
    where('candidates.created_at > ?', min_date)
  end

  # rubocop:disable Metrics/LineLength
  def self.zipcode(zipcode)
    return where(nil) if zipcode == CandidateFeature::ALL_ZIPCODES_CODE

      self.joins(:candidate_features)
          .where("properties->>'child_class' = ?", ZipcodeQuestion.child_class_property)
          .where("properties->>'option' = ?", zipcode)
    .or(
      self.joins(:candidate_features)
          .where("properties->>'child_class' = ?", AddressQuestion.child_class_property)
          .where("properties->>'postal_code' = ?", zipcode))
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
    return nil unless address_feature.present?
    Address.new(address_feature)
  end

  def zipcode
    features(ZipcodeQuestion).first&.properties&.dig('option') || address&.zipcode
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

  private

  def self.min_date(created_in)
    {
      CREATED_IN_OPTIONS[:PAST_24_HOURS] => 24.hours.ago,
      CREATED_IN_OPTIONS[:PAST_WEEK] => 1.week.ago,
      CREATED_IN_OPTIONS[:PAST_MONTH] => 1.month.ago,
      CREATED_IN_OPTIONS[:ALL_TIME] => Date.iso8601('2016-02-01')
    }[created_in]
  end
  private_class_method :min_date

  def features(question_class)
    candidate_features.select { |f| f.properties["child_class"] == question_class.child_class_property }
  end

  def ensure_candidate_has_stage
    self.stage = organization.potential_stage unless stage.present?
  end

  def add_nickname
    self.nickname = Nicknames::Generator.new(self).generate
  end
end
