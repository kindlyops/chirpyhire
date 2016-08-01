class CandidatePersonaDecorator < Draper::Decorator
  delegate_all

  def persona_features
    object.persona_features.order(deleted_at: :desc, priority: :asc)
  end
end
