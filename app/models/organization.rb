class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :accounts
  has_many :subscribers
  has_many :people, through: :subscribers, class_name: 'Person'
  has_one :subscription
  has_one :ideal_candidate
  has_one :location
  accepts_nested_attributes_for :location, reject_if: :all_blank

  has_many :suggestions, class_name: 'IdealCandidateSuggestion'
  has_many :messages

  delegate :zipcode, :city, to: :location

  def candidates
    people.joins(:candidacy)
  end

  def persisted_subscription?
    subscription.present? && subscription.persisted?
  end

  def new_subscription?
    subscription.present? && subscription.new_record?
  end

  def message(recipient:, body:)
    sent_message = messaging_client.send_message(
      to: recipient.phone_number, from: phone_number, body: body
    )

    create_message(recipient, sent_message)
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  private

  def create_message(recipient, message)
    messages.create(
      person: recipient,
      sid: message.sid,
      body: message.body,
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      direction: message.direction
    )
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
