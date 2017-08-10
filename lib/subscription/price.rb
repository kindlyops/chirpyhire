class Subscription::Price
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  attr_reader :subscription

  def call
    case active_contact_count
    when 0..50
      125
    when 51..100
      170
    when 101..150
      195
    when 151..200
      220
    when 201..500
      350
    when 501..1000
      475
    when 1001..2000
      750
    when 2001..4000
      1000
    end
  end

  def active_contact_count
    @active_contact_count ||= organization.contacts.active.count
  end

  delegate :organization, to: :subscription
end
