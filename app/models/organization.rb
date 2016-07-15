class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'

  has_many :users
  has_many :candidates, through: :users
  has_many :referrers, through: :users
  has_many :accounts, through: :users
  has_many :messages, through: :users
  has_many :activities, through: :users
  has_many :templates
  has_many :rules
  has_one :candidate_persona

  delegate :first_name, to: :contact, prefix: true

  after_create :create_candidate_persona

  def self.for(phone:)
    find_by(phone_number: phone)
  end

  def contact
    users.find_by(contact: true)
  end

  def send_message(to:, body:, from: phone_number)
    sent_message = messaging_client.send_message(to: to, body: body, from: from)

    Message.new(sid: sent_message.sid,
                body: sent_message.body,
                sent_at: sent_message.date_sent,
                direction: sent_message.direction)
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  def get_media(sid)
    messaging_client.media.get(sid)
  end

  def inbox
    Inbox.new(organization: self)
  end

  def outstanding_activities
    activities.outstanding
  end

  def conversations
    messages.conversations
  end

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
