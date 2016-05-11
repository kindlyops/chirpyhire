module Cavy
  class << self
    attr_accessor :phones

    def current_conversation
      conversation_pool["#{conversation_name}"] ||= Cavy::Conversation.new(phones)
    end

    def conversation_name
      @conversation_name ||= :default
    end

    private

    def conversation_pool
      @conversation_pool ||= {}
    end
  end
end

RSpec.configure do |config|
  config.include Cavy::DSL, type: :feature
  config.after(:each) do
    File.delete("default.yml") if File.exists?("default.yml")
  end
end
