class AnswerHandler

  def self.call(sender, inquiry, message_sid)
    new(sender, inquiry, message_sid).call
  end

  def call
    if answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      answer
    else
      create_message_task
    end
  end

  def initialize(sender, inquiry, message_sid)
    @sender = sender
    @inquiry = inquiry
    @message_sid = message_sid
  end

  private

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  attr_reader :inquiry, :sender, :message_sid

  def organization
    @organization ||= sender.organization
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  def message
    @message ||= MessageHandler.call(sender, external_message)
  end

  def create_message_task
    sender.tasks.create(taskable: message) unless sender.outstanding_task_for?(message)
  end
end
