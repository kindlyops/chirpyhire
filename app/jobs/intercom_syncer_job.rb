class IntercomSyncerJob < ApplicationJob
  def perform(organization)
    IntercomSyncer.new(organization).call
  end
end
