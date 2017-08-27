class LogSetContactStageJob < ApplicationJob
  def perform(account, stage, timestamp)
    Internal::Logger::SetContactStage.call(account, stage, timestamp)
  end
end
