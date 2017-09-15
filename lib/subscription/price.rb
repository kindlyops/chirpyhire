class Subscription::Price
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  attr_reader :subscription

  def call
    if engaged_contact_count.between?(0, 200)
      125
    elsif engaged_contact_count.between?(201, 400)
      200
    elsif engaged_contact_count.between?(401, 600)
      275
    elsif engaged_contact_count.between?(601, 800)
      350
    elsif engaged_contact_count.between?(801, 1000)
      425
    elsif engaged_contact_count.between?(1001, 1200)
      500
    elsif engaged_contact_count.between?(1201, 1400)
      575
    elsif engaged_contact_count.between?(1401, 1600)
      650
    elsif engaged_contact_count.between?(1601, 1800)
      725
    elsif engaged_contact_count.between?(1801, 2000)
      800
    elsif engaged_contact_count.between?(2001, 2200)
      875
    else
      dynamic_price(0.375)
    end
  end

  def dynamic_price(slope)
    (price_count * slope).round
  end

  def price_count
    ((engaged_contact_count / 200) * 200).floor
  end

  def engaged_contact_count
    @engaged_contact_count ||= organization.contacts.engaged.count
  end

  delegate :organization, to: :subscription
end
