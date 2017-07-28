class ImportJob < ApplicationJob
  def perform(import)
    Import::Runner.call(import)
  end
end
