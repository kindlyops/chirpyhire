class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user

  delegate :name, :phone_number, to: :user, prefix: true
  delegate :name, to: :user
  delegate :name, :phone_number, to: :last_referrer, prefix: true

  def last_referrer
    object.last_referrer.decorate
  end

  def statuses
    Candidate::STATUSES
  end

  def address
    @address ||= begin
      return NullAddress.new unless address_feature.present?
      Address.new(address_feature)
    end
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
    return ["bad_fit", "qualified", "message"] if screened? || potential?
    return ["qualified", "message"] if bad_fit?
    return ["call", "message"] if qualified?
    []
  end
end
