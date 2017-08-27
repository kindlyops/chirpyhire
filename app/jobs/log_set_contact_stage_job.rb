class LogSetContactStageJob < ApplicationJob
  def perform(account, contact)
    Internal::Logger::SetContactStage.call(account, contact)
  end
end
