class Conversation::Thought
  def initialize(thought)
    @messages = messages
    sender_and_thought, @messages = thought
    @sender, @thought = sender_and_thought
  end

  attr_reader :messages, :sender, :thought
end
