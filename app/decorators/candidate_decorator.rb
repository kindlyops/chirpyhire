class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  delegate :phone_number, to: :user, prefix: true

  def statuses
    Candidate::STATUSES
  end

  def choices
    @choices ||= begin
      return [] unless choice_features.present?
      choice_features.map {|c| Choice.new(c) }
    end
  end

  def documents
    @documents ||= begin
      return [] unless document_features.present?
      document_features.map {|c| Document.new(c) }
    end
  end

  def call_to_actions
    return ["bad_fit", "qualified", "message"] if potential?
    return ["call", "qualified", "message"] if bad_fit?
    return ["bad_fit", "hired", "message"] if qualified?
    return ["call", "bad_fit", "message"] if hired?
  end
end
