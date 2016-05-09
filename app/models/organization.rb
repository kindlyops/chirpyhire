class Organization < ActiveRecord::Base
  has_many :users
  has_many :candidates, through: :users
  has_many :referrers, through: :users
  has_many :referrals, through: :referrers
  has_many :messages, through: :users
  has_many :accounts, through: :users
  has_many :templates

  has_one :phone

  delegate :number, to: :phone, prefix: true

  def self.for(phone:)
    joins(:phone).find_by(phones: { number: phone })
  end

  def owner
    accounts.find_by(role: Account.roles[:owner])
  end

  def owner_first_name
    owner.first_name
  end

  def subscribed_candidates
    candidates.subscribed.with_phone_number
  end

  private

  def send_message(message)
    message = sms_client.send_message(message.merge(from: phone_number))
    messages.create(sid: message.sid)
  end

  def sms_client
    @sms_client ||= Sms::Client.new(self)
  end
end
