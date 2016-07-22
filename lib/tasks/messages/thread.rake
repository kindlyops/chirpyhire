namespace :messages do
  desc "Set build relationships between messages"
  task thread: :environment do |task|
    puts "Beginning threading"
    Threader.thread
    puts "Threading complete"
  end
end
