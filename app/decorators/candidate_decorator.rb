class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  delegate :phone_number, to: :user, prefix: true
  delegate :handle, to: :user
  
  def choices
    @choices ||= begin
      return [] unless choice_features.present?
      choice_features.map {|f| Choice.new(f) }
    end
  end

  def yes_nos
    @yes_nos ||= begin
      return [] unless yes_no_features.present?
      yes_no_features.map {|f| YesNo.new(f) }
    end
  end

  def documents
    @documents ||= begin
      return [] unless document_features.present?
      document_features.map {|f| Document.new(f) }
    end
  end

  def call_to_actions
    return ["change_stages", "message"]
  end
end
