class IceBreaker
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def call
    open_conversation.tap do |conversation|
      Broadcaster::Conversation.broadcast(conversation)
    end
  end

  def open_conversation
    @open_conversation ||= begin
      contact.existing_open_conversation || create_conversation
    end
  end

  def create_conversation
    contact.conversations.create!(inbox: team.inbox)
  end

  delegate :team, to: :contact
  delegate :inbox, to: :team
end
