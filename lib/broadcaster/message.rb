class Broadcaster::Message
  def self.broadcast(message)
    new(message).broadcast
  end

  def initialize(message)
    @message = message
  end

  def broadcast
    MessagesChannel.broadcast_to(contact, render_message)
  end

  private

  attr_reader :message

  def inbox_conversation
    contact.inbox_conversations.first
  end

  def day
    inbox_conversation.day(message.external_created_at.to_date)
  end

  def thought
    thoughts.find { |thought| thought.messages.include?(message) }
  end

  delegate :conversation, :person, to: :message
  delegate :contact, to: :conversation
  delegate :thoughts, to: :day

  def render_message
    return render_day if new_day?
    return render_thought if new_thought?

    MessagesController.render partial: 'conversations/message', locals: {
      message: message, message_counter: message_counter
    }
  end

  def render_day
    MessagesController.render partial: 'conversations/day', locals: {
      day: day
    }
  end

  def render_thought
    MessagesController.render partial: 'conversations/thought', locals: {
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
