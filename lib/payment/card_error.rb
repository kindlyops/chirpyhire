module Payment
  class CardError < StandardError
    def initialize(error)
      @error = error
    end
    attr_reader :error
    delegate :message, to: :error
  end
end
