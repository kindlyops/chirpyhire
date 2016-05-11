module Cavy
  class MessagingTest

    def initialize(driver)
      @driver = driver
    end

    def message(from, message)
      driver.submit('post','twilio/text', {"From" => from, "Body" => message.body, "To" => message.to, "MessageSid" => message.sid })
      log(message)
    end

    def thread(phones:)
      select_messages_between(phones: phones).map(&:body)
    end

    def log(message)
      File.write("default.yml", append(message))
    end

    def file
      @file ||= File.open("default.yml", "a+")
    end

    def yaml
      @yaml ||= begin
        yaml = YAML.load(file) || []
        file.close
        yaml
      end
    end

    def append(message)
      YAML.dump(yaml << message)
    end

    def select_messages_between(phones:)
      yaml.select do |message|
        message.from == phones.first && message.to == phones.last || message.from == phones.last && message.to == phones.first
      end
    end

    private

    attr_reader :driver
  end
end
