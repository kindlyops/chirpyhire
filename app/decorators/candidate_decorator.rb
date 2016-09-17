# frozen_string_literal: true
class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  delegate :phone_number, to: :user, prefix: true
  delegate :handle, to: :user

  def statuses
    Candidate::STATUSES
  end

  def choices
    @choices ||= begin
      return [] unless choice_features.present?
      choice_features.map { |f| Choice.new(f) }
    end
  end

  def yes_nos
    @yes_nos ||= begin
      return [] unless yes_no_features.present?
      yes_no_features.map { |f| YesNo.new(f) }
    end
  end

  def documents
    @documents ||= begin
      return [] unless document_features.present?
      document_features.map { |f| Document.new(f) }
    end
  end

  def call_to_actions
    return %w(bad_fit qualified message) if potential?
    return %w(call qualified message) if bad_fit?
    return %w(bad_fit hired message) if qualified?
    return %w(call bad_fit message) if hired?
  end
end
