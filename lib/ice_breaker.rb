class IceBreaker
  def self.call(contact, phone_number)
    new(contact, phone_number).call
  end

  def initialize(contact, phone_number)
    @contact = contact
    @phone_number = phone_number
  end

  attr_reader :contact, :phone_number

  def call
    open_conversation.tap do |conversation|
      Broadcaster::Conversation.broadcast(conversation)
    end
  end

  def open_conversation
    @open_conversation ||= begin
      existing_open_conversation || create_conversation
    end
  end

  def existing_open_conversation
    open_conversations.find_by(phone_number: phone_number)
  end

  def assignment_rule
    assignment_rules.find_by(phone_number: phone_number)
  end

  def create_conversation
    conversations.create!(inbox: inbox, phone_number: phone_number)
  end

  delegate :organization, :conversations, :open_conversations, to: :contact
  delegate :assignment_rules, to: :organization
  delegate :inbox, to: :assignment_rule
end
