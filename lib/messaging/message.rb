class Messaging::Message
  def initialize(message)
    @message = message
  end

  def num_media
    message.num_media.to_i
  end

  def media
    return [] if num_media.zero?
    Messaging::Media.new(message.media)
  end

  delegate :sid, :body, :from, :to, :direction,
           :date_sent, :date_created, to: :message

  private

  attr_reader :message
end
