class Threader
  def initialize(message)
    @message = message
  end

  def call
    message.update(child: next_message) if next_message.present?
    preceding_message.update(child: message) if preceding_message.present?
  end

  def self.thread
    Message.find_each do |message|
      new(message).call
    end
  end

  private

  attr_reader :message

  def preceding_message
    @preceding_message ||= user.messages.where("external_created_at < ?", message.external_created_at).order(:external_created_at).last
  end

  def next_message
    @next_message ||= user.messages.where("external_created_at > ?", message.external_created_at).order(:external_created_at).first
  end

  def user
    @user ||= message.user
  end
end
