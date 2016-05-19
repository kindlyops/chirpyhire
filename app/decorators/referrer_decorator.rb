class ReferrerDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  delegate :name, to: :user
  delegate :name, to: :last_referred, prefix: true
  delegate :created_at, to: :last_referral, prefix: true

  def last_referred
    object.last_referred.decorate
  end
end
