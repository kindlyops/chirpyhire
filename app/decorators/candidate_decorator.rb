class CandidateDecorator < Draper::Decorator
  delegate_all

  decorates_association :user

  delegate :name, to: :user
  delegate :name, :phone_number, to: :last_referrer, prefix: true

  def last_referrer
    object.last_referrer.decorate
  end

  def statuses
    Candidate::STATUSES
  end
end
