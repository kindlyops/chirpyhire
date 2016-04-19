class Organization < ActiveRecord::Base
  has_many :accounts
  has_many :leads
  has_many :referrals, through: :leads
  has_many :referrers
  has_many :messages
  has_many :subscriptions
  has_one :phone

  delegate :number, to: :phone, prefix: true

  def sms_client
    @sms_client ||= Sms::Client.new(self)
  end

  def ask(lead, question)
    send_message(to: lead.phone_number, body: question.body, from: phone_number)
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
end
