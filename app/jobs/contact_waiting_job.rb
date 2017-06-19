class ContactWaitingJob < ApplicationJob
  def perform(conversation, read_receipt)
    ContactWaiting.call(conversation, read_receipt)
  end
end
