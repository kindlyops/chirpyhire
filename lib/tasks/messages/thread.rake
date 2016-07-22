namespace :messages do
  desc "Set build relationships between messages"
  task thread: :environment do |task|
    Threader.thread
  end
end
