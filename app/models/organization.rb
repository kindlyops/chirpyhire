class Organization < ActiveRecord::Base
  belongs_to :industry
  has_many :accounts
  has_many :leads
  has_many :subscribed_leads, -> { subscribed }, class_name: "Lead"
  has_many :referrals, through: :leads
  has_many :referrers
  has_many :messages
  has_many :subscriptions
  has_many :questions
  has_many :searches, through: :accounts
  has_one :phone

  delegate :number, to: :phone, prefix: true
  delegate :questions, to: :industry

  def ask(inquiry, prelude: false)
    message = send_message(
      to: inquiry.lead_phone_number,
      body: inquiry.body(prelude: prelude),
      from: phone_number
    )
    inquiry.message = message
    inquiry.save
  end

  def owner
    accounts.find_by(role: Account.roles[:owner])
  end

  def owner_first_name
    owner.first_name
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
