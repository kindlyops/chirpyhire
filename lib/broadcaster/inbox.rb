class Broadcaster::Inbox
  def initialize(account, conversation)
    @account = account
    @conversation = conversation
  end

  def broadcast
    InboxChannel.broadcast_to(account, response)
  end

  private

  attr_reader :account, :conversation

  def response
    {
      conversation: conversation.to_builder.target!,
      conversations_count: account.inbox_conversations.count
    }
  end
end
