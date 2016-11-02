class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  delegate :phone_number, to: :user, prefix: true

  def choices
    @choices ||= make_feature_view_model(choice_features, Choice)
  end

  def yes_nos
    @yes_nos ||= make_feature_view_model(yes_no_features, YesNo)
  end

  def documents
    @documents ||= make_feature_view_model(document_features, Document)
  end

  def call_to_actions
    %w(change_stage message)
  end

  private

  def make_feature_view_model(features, view_class)
    return [] unless features.present?
    features.map { |f| view_class.new(f) }
  end
end
