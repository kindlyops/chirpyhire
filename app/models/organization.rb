class Organization < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'

  has_many :users
  has_many :candidates, through: :users
  has_many :referrers, through: :users
  has_many :accounts, through: :users
  has_many :messages, through: :users
  has_many :tasks, through: :users
  has_many :templates
  has_many :rules
  has_many :actions
  has_one :profile

  delegate :first_name, to: :contact, prefix: true

  def self.for(phone:)
    find_by(phone_number: phone)
  end

  def contact
    users.find_by(contact: true)
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

  def inbox
    Inbox.new(organization: self)
  end

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
