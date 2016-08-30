namespace :internal do
  desc "Syncs with intercom daily"
  task intercom: :environment do |task|
    Organization.find_each do |organization|
      IntercomSyncerJob.perform_later(organization)
    end
  end
end
