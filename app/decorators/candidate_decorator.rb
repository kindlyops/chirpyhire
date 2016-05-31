class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user

  delegate :name, :phone_number, to: :user, prefix: true
  delegate :name, :phone_number, to: :last_referrer, prefix: true

  def last_referrer
    object.last_referrer.decorate
  end

  def statuses
    Candidate::STATUSES
  end

  def screening_status
    subscribed? ? "Screening in Progress" : "Screening not in Progress"
  end

  def color
    "success"
  end

  def body
    "Woohoo! This candidate is ready for review."
  end

  def icon_class
    "fa-star"
  end
end
