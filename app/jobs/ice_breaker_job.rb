class IceBreakerJob < ApplicationJob
  def perform(contact)
    IceBreaker.call(contact)
  end
end
