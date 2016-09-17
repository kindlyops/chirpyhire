# frozen_string_literal: true
namespace :internal do
  desc 'Syncs with intercom'
  task intercom: :environment do |_task|
    Organization.find_each do |organization|
      IntercomSyncerJob.perform_later(organization)
    end
  end
end
