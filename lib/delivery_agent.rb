class DeliveryAgent
  def self.call(message)
    new(message).call
  end

  def initialize(message)
    @message = message
  end

  attr_reader :message

  def call
    return if assignment_rule.blank?
    inbox.receive(message)
  end

  def assignment_rule
    assignment_rules.find_by(phone_number: phone_number)
  end

  def phone_number
    phone_numbers.find_by(phone_number: message.to)
  end

  delegate :organization, to: :message
  delegate :assignment_rules, :phone_numbers, to: :organization
  delegate :inbox, to: :assignment_rule
end
