class CandidatePersonaDecorator < Draper::Decorator
  delegate_all

  def icon_class
    "fa-filter"
  end

  def label
    "Candidate Persona"
  end

  def title
    "Screen candidate"
  end

  def subtitle
    "Ensure basic requirements are met."
  end
end
