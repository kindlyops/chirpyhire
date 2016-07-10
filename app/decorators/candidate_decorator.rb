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
end
