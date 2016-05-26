class Organization < ActiveRecord::Base
  has_many :users
  has_many :candidates, through: :users
  has_many :referrers, through: :users
  has_many :referrals, through: :referrers
  has_many :accounts, through: :users
  has_many :messages, through: :users
  has_many :tasks, through: :messages
  has_many :templates
  has_many :questions, through: :templates
  has_many :notices, through: :templates
  has_many :automations
  has_many :triggers
  has_many :actions

  has_one :phone

  delegate :number, to: :phone, prefix: true
  delegate :first_name, to: :contact, prefix: true

  def self.for(phone:)
    joins(:phone).find_by(phones: { number: phone })
  end

  def contact
    users.find_by(contact: true)
  end

  def screen
    automations.first
  end

  def subscribed_candidates
    candidates.subscribed
  end

  def send_message(to:, body:, from: phone_number)
    messaging_client.send_message(to: to, body: body, from: from)
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
