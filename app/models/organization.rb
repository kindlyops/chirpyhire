class Organization < ActiveRecord::Base
  has_many :users
  has_many :candidates, through: :users
  has_many :referrers, through: :users
  has_many :referrals, through: :referrers
  has_many :accounts, through: :users
  has_many :templates
  has_many :rules

  has_one :phone

  delegate :number, to: :phone, prefix: true
  delegate :first_name, to: :contact, prefix: true

  def self.for(phone:)
    joins(:phone).find_by(phones: { number: phone })
  end

  def contact
    users.find_by(contact: true)
  end

  def subscribed_candidates
    candidates.subscribed
  end

  def send_message(to:, body:)
    messaging_client.send_message(to: to, body: body, from: phone_number)
  end

  def messages
    messaging_client.messages
  end

  def questions
    templates.joins(:question).map(&:question)
  end

  def notices
    templates.joins(:notice).map(&:notice)
  end

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
