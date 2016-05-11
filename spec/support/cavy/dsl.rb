module Cavy
  module DSL
    def conversation
      Cavy.current_conversation
    end

    Conversation::DSL_METHODS.each do |method|
      define_method method do |*args, &block|
        conversation.send method, *args, &block
      end
    end
  end

  extend(Cavy::DSL)
end
