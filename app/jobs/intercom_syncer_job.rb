# frozen_string_literal: true
class IntercomSyncerJob < ApplicationJob
  def perform(organization)
    IntercomSyncer.new(organization).call
  end
end
