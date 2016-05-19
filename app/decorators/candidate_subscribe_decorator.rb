class CandidateSubscribeDecorator < CandidateDecorator
  def template_name
    ""
  end

  def title
    "Subscribes"
  end

  def subtitle
    "Candidate opts-in to receiving communications via text message."
  end

  def icon_class
    "fa-hand-paper-o"
  end
end
