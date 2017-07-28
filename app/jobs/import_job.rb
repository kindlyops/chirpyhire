class ImportJob < ApplicationJob
  def perform(import)
    Importer.call(import)
  end
end
