class Broadcaster::Message
  def initialize(message)
    @message = message
  end

  def broadcast
    MessagesChannel.broadcast_to(contact, render_message)
  end

  private

  attr_reader :message

  def contact
    @contact ||= contacts.find_by(person: person)
  end

  def conversation
    contact.conversations.first
  end

  def day
    conversation.day(message.external_created_at.to_date)
  end

  def thought
    thoughts.find { |thought| thought.messages.include?(message) }
  end

  delegate :organization, :person, to: :message
  delegate :contacts, to: :organization
  delegate :thoughts, to: :day

  def render_message
    return render_day if new_day?
    return render_thought if new_thought?

    MessagesController.render partial: 'messages/message', locals: {
      message: message, message_counter: message_counter
    }
  end

  def render_day
    MessagesController.render partial: 'messages/day', locals: {
      day: day
    }
  end

  def render_thought
    MessagesController.render partial: 'messages/thought', locals: {
      thought: thought
    }
  end

  def new_day?
    day.thoughts.first == thought
  end

  def new_thought?
    thought.messages.first == message
  end

  def message_counter
    thought.messages.find_index { |m| m == message } + 1
  end
end
