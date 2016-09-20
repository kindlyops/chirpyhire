namespace :messages do
  desc 'Set build relationships between messages'
  task thread: :environment do |_task|
    puts 'Beginning threading'
    Threader.thread
    puts 'Threading complete'
  end
end
