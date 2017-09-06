class Subscription::Price
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  attr_reader :subscription

  def call
    if engaged_contact_count.between?(0, 50)
      125
    elsif engaged_contact_count.between?(51, 100)
      150
    elsif engaged_contact_count.between?(101, 200)
      175
    elsif engaged_contact_count.between?(201, 300)
      225
    elsif engaged_contact_count.between?(301, 400)
      250
    elsif engaged_contact_count.between?(401, 500)
      275
    elsif engaged_contact_count.between?(501, 600)
      315
    elsif engaged_contact_count.between?(601, 700)
      350
    elsif engaged_contact_count.between?(701, 800)
      380
    elsif engaged_contact_count.between?(801, 900)
      400
    elsif engaged_contact_count.between?(901, 1000)
      450
    elsif engaged_contact_count.between?(1001, 2000)
      dynamic_price(0.43)
    elsif engaged_contact_count.between?(2001, 3000)
      dynamic_price(0.42)
    else
      dynamic_price(0.41)
    end
  end

  def dynamic_price(slope)
    (price_count * slope).round
  end

  def price_count
    ((engaged_contact_count / 100) * 100).floor
  end

  def engaged_contact_count
    @engaged_contact_count ||= organization.contacts.engaged.count
  end

  delegate :organization, to: :subscription
end
