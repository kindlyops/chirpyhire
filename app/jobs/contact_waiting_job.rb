class ContactWaitingJob < ApplicationJob
  def perform(inbox_conversation, read_receipt)
    ContactWaiting.call(inbox_conversation, read_receipt)
  end
end
