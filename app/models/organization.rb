class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :accounts
  has_many :leads
  has_many :people, through: :leads, class_name: 'Person'
  has_one :subscription
  has_one :ideal_candidate
  has_many :suggestions, class_name: 'IdealCandidateSuggestion'
  has_many :messages

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
    sent_message = message_client.send_message(
      to: recipient.phone_number, from: phone_number, body: body
    )

    create_message(recipient, sent_message)
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

  def message_client
    @message_client ||= Messaging::Client.new(self)
  end
end
