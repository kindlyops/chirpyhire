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
    "Ensure candidate matches your Candidate Persona."
  end
end
