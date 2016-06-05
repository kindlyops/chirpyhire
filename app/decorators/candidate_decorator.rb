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

  def screening_status
    subscribed? ? "Screening in Progress" : "Screening not in Progress"
  end

  def color
    "complete"
  end

  def body
    "Woohoo! #{user.from_short}'s profile is completed. Please review at your convenience."
  end

  def icon_class
    "fa-star"
  end

  def subtitle
    "Candidate answers all screening questions"
  end

  def attachments
    []
  end
end
