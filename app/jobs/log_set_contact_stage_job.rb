class LogSetContactStageJob < ApplicationJob
  def perform(account, stage, contact, timestamp)
    Internal::Logger::SetContactStage.call(account, stage, contact, timestamp)
  end
end
