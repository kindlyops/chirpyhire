module Cavy
  class Conversation
    DSL_METHODS = [:message]

    def initialize(phones)
      @phones = phones
    end

    def thread
      driver.thread(phones: phones)
    end

    def include?(body)
      thread.include?(body)
    end

    def message(from, message)
      driver.message(from, message)
    end

    def driver
      @driver ||= MessagingTest.new(Capybara.current_session.driver)
    end

    private

    attr_reader :phones
  end
end
